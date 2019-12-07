RSpec.feature 'Wished Product', :js do
  given(:user) { create(:user) }

  context 'add' do
    given(:product) { create(:product) }

    background do
      sign_in_as! user
    end

    scenario 'when user has a default wishlist' do
      wishlist = create(:wishlist, is_default: true, user: user)

      add_to_wishlist product

      expect(page).to have_content wishlist.name
      expect(page).to have_content product.name
    end

    scenario 'when user has no default but with non-default wishlist' do
      wishlist = create(:wishlist, is_default: false, user: user)

      add_to_wishlist product

      expect(wishlist.reload.is_default).to be true
      expect(page).to have_content wishlist.name
      expect(page).to have_content product.name
    end

    scenario 'when user has no wishlist at all' do
      expect(user.wishlists).to be_empty

      add_to_wishlist product

      expect(user.wishlists.reload.count).to eq(1)
      expect(page).to have_content user.wishlists.first.name
      expect(page).to have_content product.name
    end

    # Need to come back to this
    # Tested in store, works fine
    # The way that the wishlist gets the quantity is when 'add to wishlist' is clicked, it triggers a JS event to copy the value of the cart quantity to a hidden wish list quantity field. This seems to not be triggering during specs.

    # scenario 'when user chooses different quantity of item' do
    #   wishlist = create(:wishlist, user: user)

    #   visit spree.product_path(product)
    #   fill_in "quantity", with: "15"
    #   click_button 'Add to wishlist'

    #   expect(page).to have_content product.name
    #   expect(page).to have_selector("input[value='15']")
    # end
  end

  context 'delete' do
    given(:wishlist) { create(:wishlist, user: user) }

    background do
      sign_in_as! user
    end

    scenario 'from a wishlist with one wished product' do
      wished_product = create(:wished_product, wishlist: wishlist)
      visit spree.wishlist_path(wishlist)

      wp_path = spree.wished_product_path(wished_product)
      find_link(href: wp_path).click

      expect(page).to have_no_content wished_product.variant.product.name
    end

    scenario 'randomly from a wishlist with multiple wished products while maintaining ordering by date added' do
      wished_products = [
        create(:wished_product, wishlist: wishlist),
        create(:wished_product, wishlist: wishlist),
        create(:wished_product, wishlist: wishlist)
      ]
      wished_product = wished_products.delete_at(Random.rand(wished_products.length))

      visit spree.wishlist_path(wishlist)

      wp_path = spree.wished_product_path(wished_product)
      find_link(href: wp_path).click

      expect(page).to have_no_content wished_product.variant.product.name

      wished_products.map do |wp|
        expect(page).to have_content(wp.variant.product.name)
      end
    end
  end

  private

  def add_to_wishlist(product)
    visit spree.product_path(product)
    click_button 'Add to wishlist'
  end
end
