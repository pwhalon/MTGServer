require 'net/http'
require 'uri'
require 'singleton'
require 'json'

# Class to encompass interacting with the Scryfall API
class ScryfallClient
  include Singleton

  SCRYFALL_URI = 'https://api.scryfall.com'.freeze
  LIST_CARDS_API = '/cards'.freeze
  GET_MULTIVERSE_CARD_API = '/cards/multiverse/'.freeze
  BULK_CARD_URL_API = '/bulk-data'.freeze
  SEARCH_CARDS_API = '/cards/search/'.freeze

  # Will likely never need to use as there is a daily dump of the current cards in Scryfalls
  # database. Can use that instead of making a bunch of network calls.
  def list_cards
    initial_page = 0
    card_list = []

    puts "Initial list call\n"
    cards_response = list(initial_page)

    return card_list if cards_response.blank?

    card_list += cards_response['data']

    while cards_response['has_more'] == true
      puts "More to get making call to Scryfall page: #{cards_response.fetch('next_page')}\n"

      cards_response = get(URI(cards_response.fetch('next_page')))
      card_list += cards_response['data']

      # Per Scryfall request no more than 10 requests per second on average.
      puts "Call successful sleeping before next request\n"
      sleep(0.5)
    end

    puts "All calls successful\n"
    cards_list
  end

  def get_card_data(multiverse_id)
    uri = URI(SCRYFALL_URI + GET_MULTIVERSE_CARD_API + multiverse_id)

    get(uri)
  end

  def get_bulk_data_url
    uri = URI(SCRYFALL_URI + BULK_CARD_URL_API)

    bulk_options = get(uri)

    return nil if bulk_options.blank?

    default_option = bulk_options['data'].find { |option| option['type'] == 'default_cards' }

    if default_option
      return default_option['download_uri']
    else
      return nil
    end
  end

  def get_all_prints(name)
    initial_page = 0
    card_list = []

    Rails.logger.info "Initial get_all_prints call\n"
    cards_response = get_cards(name, initial_page)

    return card_list if cards_response.blank?

    card_list += cards_response['data']

    while cards_response['has_more'] == true
      Rails.logger.info "More to get making call to Scryfall page: #{cards_response.fetch('next_page')}\n"

      cards_response = get(URI(cards_response.fetch('next_page')))
      card_list += cards_response['data']

      # Per Scryfall request no more than 10 requests per second on average.
      Rails.logger.info "Call successful sleeping before next request\n"
      sleep(0.5)
    end

    Rails.logger.info "All calls successful\n"
    card_list
  end

  private

  def get_cards(name, page)
    params = {
      q: name,
      unique: 'prints',
      page: page
    }

    uri = URI(SCRYFALL_URI + SEARCH_CARDS_API)

    uri.query = URI.encode_www_form(params)

    get(uri)
  end

  def list(page)
    params = {
      page: page,
      format: 'json'
    }

    uri = URI(SCRYFALL_URI + LIST_CARDS_API)
    uri.query = URI.encode_www_form(params)

    get(uri)
  end

  def get(uri)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      Rails.logger.warn("Response code: #{response.code}\nResponse.body: #{JSON.parse(response.body)}")
      nil
    end
  end
end