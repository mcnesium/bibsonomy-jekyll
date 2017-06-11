# spec_helper.rb
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "jekyll"
require "bibsonomy-jekyll"

Jekyll.logger.log_level = :error

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = "random"

  SOURCE_DIR = File.expand_path("../fixtures", __FILE__)
  DEST_DIR   = File.expand_path("../dest", __FILE__)

  def source_dir(*files)
    File.join(SOURCE_DIR, *files)
  end

  def dest_dir(*files)
    File.join(DEST_DIR, *files)
  end

  CONFIG_DEFAULTS = {
    "source"      => source_dir,
    "destination" => dest_dir,
    "gems"        => ["bibsonomy-jekyll"]
  }.freeze

  def make_page(options = {})
    page      = Jekyll::Page.new(site, CONFIG_DEFAULTS["source"], "", "page.md")
    page.data = options
    page
  end

  def make_site(options = {})
    site_config = Jekyll.configuration(CONFIG_DEFAULTS.merge(options))
    # get api key and user name from environment (configured via
    # .travis.yml on Travis or manually when testing locally)
    site_config["bibsonomy"] = {"user" => ENV['BIBSONOMY_USER_NAME'], "apikey" => ENV['BIBSONOMY_API_KEY']}
    Jekyll::Site.new(site_config)
  end

  def make_context(registers = {}, environments = {})
    Liquid::Context.new(environments, {}, 
      { :site => site, :page => page }.merge(registers))
  end
end
