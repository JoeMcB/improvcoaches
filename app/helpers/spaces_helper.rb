module SpacesHelper
  # Returns the given URL only when it uses http/https, otherwise nil.
  # Space links are stored data; without this, a `javascript:` URL saved
  # to a space becomes a clickable XSS vector on the space's page.
  def safe_external_url(url)
    uri = URI.parse(url.to_s.strip)
    url if uri.is_a?(URI::HTTP)
  rescue URI::InvalidURIError
    nil
  end
end
