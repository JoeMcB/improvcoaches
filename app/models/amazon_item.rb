# Utility class for interacting with the Amazon product API.
# Wraps what we want from API into easy functions.
class AmazonItem
  def initialize(amazon_id)
    @response = AmazonItem.lookup(amazon_id)
    @success = @response['ItemLookupResponse']['Items']['Request']['Errors'].nil?
    @item = @response['ItemLookupResponse']['Items']['Item'] if @success
  end

  def success?
    @success
  end

  def item
    @item
  end

  def amazon_id
    item['ASIN']
  end

  def title
    item['ItemAttributes']['Title']
  end

  def price
    # Get price either from Amazon, or reseller if available.
    # Strip $ from price.
    if(item['Offers']['TotalOffers'] != '0') # Available from Amazon
      item['Offers']['Offer']['OfferListing']['Price']['FormattedPrice'][1..-1].to_d
    else # Get used price
      item['OfferSummary']['LowestNewPrice']['FormattedPrice'][1..-1].to_d
    end
  end

  def url
    item['DetailPageURL']
  end

  def item_type
    case item['ItemAttributes']['ProductGroup']
    when 'Book'
      'book'
    when 'DVD'
      'dvd'
    else
      'resource'
    end
  end

  def description
    if(item['EditorialReviews']['EditorialReview'].is_a? Array)
      item['EditorialReviews']['EditorialReview'].first['Content']
    else
      item['EditorialReviews']['EditorialReview']['Content']
    end
  end

  def image(size = 'Large') # Small, Medium, Large, Thumbnail, etc.  See Amazon API docs.
    item["#{size.titleize}Image"]['URL']
  end

  class << self
    def lookup(amazon_id)
      request = Vacuum.new
      request.configure(
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        associate_tag: ENV['AMAZON_AFFILIATE_TAG']
      )

      response = request.item_lookup(
        query: {
          'ResponseGroup' => 'Large',
          'ItemId' => amazon_id
        }
        ).parse
    end
  end
end