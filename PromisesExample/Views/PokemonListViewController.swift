import UIKit

class PokemonListViewController: UITableViewController {
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let api: PokemonApi = PokemonApiImpl()
    private var pokemon: [PokemonApiLink] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func fetchData() {
        showLoadingIndicator()
        api.fetchPokemon()
            .then(on: .main) { [weak self] response in
                guard let self = self else {
                    return
                }
                self.pokemon = response.results
                self.tableView.reloadData()
            }
            .catch(on: .main) { error in
                debugPrint(error)
            }
            .always(on: .main) { [weak self] in
                self?.hideLoadingIndicator()
            }
    }
    
    private func showLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = pokemon[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemon", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = pokemon.name.capitalized
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showLoadingIndicator()
        api.fetchDetails(for: pokemon[indexPath.row])
            .then(on: .main) { [weak self] details in
                self?.performSegue(withIdentifier: "details", sender: details)
            }
            .catch(on: .main) { error in
                debugPrint(error)
            }
            .always(on: .main) { [weak self] in
                self?.hideLoadingIndicator()
            }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destination {
        case let viewController as PokemonDetailsViewController:
            viewController.details = (sender as! PokemonDetails)
        default:
            return
        }
    }
}


