
extension WMFFeedArticlePreview {
    public func descriptionOrSnippet() -> String? {
        if let wikidataDescription = wikidataDescription, wikidataDescription.characters.count > 0 {
            let articleLanguage = (articleURL as NSURL?)?.wmf_language
            return wikidataDescription.wmf_stringByCapitalizingFirstCharacter(usingWikipediaLanguage: articleLanguage)
        }
        if let snippet = snippet, snippet.characters.count > 0 {
            return String(snippet.characters.prefix(128))
        }
        return nil
    }
}
