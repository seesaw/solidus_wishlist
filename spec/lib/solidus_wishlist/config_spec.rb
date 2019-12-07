RSpec.describe SolidusWishlist::Config do
  let(:config) { described_class }

  context 'SolidusWishlist::Config' do
    it 'should expose use_deface config param' do
      expect(config).to respond_to :use_deface
    end

    it 'should default to true' do
      expect(config.use_deface).to be_truthy
    end

    it '#without_deface! should set use_deface to false' do
      config.without_deface!
      expect(config.use_deface).to be_falsy
    end
  end
end
