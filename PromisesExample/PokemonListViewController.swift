import UIKit

class PokemonListViewController: UIViewController {
    
    // MARK: - Views / Outlets
    @IBOutlet private var tableView: UITableView!
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    private let api: PokemonApi = PokemonApiImpl()
    private var pokemon: [PokemonQuery] = []
    
    // MARK: - Lifecycle
    
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
            .catch(on: .main) { [weak self] _ in
                self?.showErrorAlert()
            }
            .always(on: .main) { [weak self] in
                self?.hideLoadingIndicator()
            }
    }
    
    private func showLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "An error occurred", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = pokemon[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemon", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = pokemon.name.capitalized
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
