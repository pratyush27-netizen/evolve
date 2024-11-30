import SwiftUI
import Combine

class ExploreViewModel: ObservableObject {
    @Published var journeys: [Journey] = []
    @Published var filteredJourneys: [Journey] = []
    @Published var searchText: String = ""
    @Published var selectedCategories: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isPaginating: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    let categories = ["All", "Work", "Finance", "Self-Care", "Social"]
    
    private var currentPage = 1
    private var totalPages = 1
    private let baseURL = "https://fe76-106-219-165-128.ngrok-free.app/data"
    
    init() {
        Publishers.CombineLatest($searchText, $selectedCategories)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { [unowned self] (text, categories) in
                filterJourneys(searchText: text, selectedCategories: categories)
            }
            .assign(to: &$filteredJourneys)
    }
    
    // MARK: - Fetch Data from API
    func fetchJourneys() {
        if let cachedJourneys = loadFromCache() {
            print("Loading from cache...")
            self.journeys = cachedJourneys
            self.filteredJourneys = self.journeys
            self.isLoading = false
            return
        }
        
        guard let url = URL(string: "\(baseURL)?page=\(currentPage)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        isLoading = currentPage == 1
        errorMessage = nil
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: [Journey].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                self.isPaginating = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] journeys in
                guard let self = self else { return }
                print("Fetching from network...")
                self.journeys.append(contentsOf: journeys)
                self.saveToCache(self.journeys)
                self.filteredJourneys = self.journeys
            })
            .store(in: &cancellables)
    }
    private func filterJourneys(searchText: String, selectedCategories: Set<String>) -> [Journey] {
        var result = journeys
        
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }

        if !selectedCategories.isEmpty, !selectedCategories.contains("All") {
            print("Selected categories for filtering: \(selectedCategories)")
            result = result.filter { journey in
                let matchesCategory = selectedCategories.contains { category in
                    let normalizedCategory = category.lowercased().replacingOccurrences(of: " ", with: "-")
                    let normalizedJuLabel = journey.juLabel.lowercased()
                    let match = normalizedJuLabel.contains(normalizedCategory)
                    return match
                }
                return matchesCategory
            }
        }
        
        return result
    }
    
    // MARK: Pagination
    func fetchNextPageIfNeeded(currentItem: Journey?) {
        guard let currentItem = currentItem else {
            return
        }
        
        if let index = journeys.firstIndex(where: { $0.id == currentItem.id }) {
            if index >= journeys.count - 3 {
                if currentPage < totalPages, !isPaginating {
                    currentPage += 1
                    isPaginating = true
                    fetchJourneys()
                }
            }
        }
    }
    
    // MARK: Caching
    func saveToCache(_ journeys: [Journey]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(journeys)
            UserDefaults.standard.set(data, forKey: "cachedJourneys")
        } catch {
            print("unable to load journeys for caching: \(error.localizedDescription)")
        }
    }
    
    func loadFromCache() -> [Journey]? {
        guard let data = UserDefaults.standard.data(forKey: "cachedJourneys") else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let journeys = try decoder.decode([Journey].self, from: data)
            return journeys
        } catch {
            return nil
        }
    }
}
