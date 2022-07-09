import UIKit

class PokemonDetailsViewController: UITableViewController {
    
    var details: PokemonDetails!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = details.name.capitalized
    }
    
    // MARK: - UITableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        DetailSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch DetailSection(rawValue: section)! {
        case .details:
            return 1
        case .types:
            return details.types.count
        case .stats:
            return details.stats.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        DetailSection(rawValue: section)!.sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath)
        var config = cell.defaultContentConfiguration()
        switch DetailSection(rawValue: indexPath.section)! {
        case .details:
            config.text = "Weight"
            config.secondaryText = String(details.weight)
        case .types:
            config.text = details.types[indexPath.row].type.name
            config.secondaryText = nil
        case .stats:
            let stat = details.stats[indexPath.row]
            config.text = stat.stat.name
            config.secondaryText = String(stat.baseStat)
        }
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private enum DetailSection: Int, CaseIterable {
    case details
    case types
    case stats
    
    var sectionTitle: String {
        switch self {
        case .details:
            return "Details"
        case .types:
            return "Types"
        case .stats:
            return "Stats"
        }
    }
}
