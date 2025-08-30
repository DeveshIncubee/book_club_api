require_relative "../../rails_helper"

RSpec.describe ExternalApi::KingBooksService, type: :service do
  subject(:service) { described_class.new }

  describe '#seach_by_id', :vcr do
    it "fetches a story by ID successfully" do
      story = service.search_by_id(18)

      expect(story).to be_a(Hash)
      expect(story["data"]).not_to be_nil
      expect(story["errors"]).to be_empty
    end

    it "returns nil for invalid ID" do
      story = service.search_by_id(-1)

      expect(story).to be_a(Hash)
      expect(story["data"]).to be_nil
      expect(story["errors"]).not_to be_empty
      expect(story["errors"]).to include("Book not found")
    end
  end
end
