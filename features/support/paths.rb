module NavigationHelpers
  def path_to(page_name)
    case page_name
 
    when /the home\s?page/
      '/'
    when /the About Us\s?page/
      about_path
    when /the Contact Us\s?page/
      contact_path
    when /the Privacy\s?page/
      privacy_path
    when /the customers\s?page/ 
      customers_path
    when /Alex Egan details\s?page/
      customer_path(@alexe)
    when /edit Melanie's\s?record/
      edit_customer_path(@melanie) 
    when /the new customer\s?page/
      new_customer_path

    when /the addresses\s?page/ 
      addresses_path
    when /the new address\s?page/
      new_address_path
    when /edit Melanie's\s?address/
      edit_address_path(@melanie_a1)

    when /the orders\s?page/ 
      orders_path
    when /Valentine's Day order/
      order_path(@alexe_o1)
    when /the new order\s?page/
      new_order_path

    # when /the principles details\s?page/
    #   curriculum_path(@principles)
    # when /edit the nimzo\s?page/
    #   edit_curriculum_path(@nimzo)    
    # when /the new curriculum\s?page/
    #   new_curriculum_path
    # when /the instructors\s?page/ 
    #   instructors_path
    # when /Mike Ferraco details\s?page/
    #   instructor_path(@mike)
    # when /edit Patrick's\s?page/
    #   edit_instructor_path(@patrick)    
    # when /the new instructor\s?page/
    #   new_instructor_path
    # when /the camps\s?page/ 
    #   camps_path
    # when /the camp1 details\s?page/
    #   camp_path(@camp1)
    # when /edit camp1's\s?page/
    #   edit_camp_path(@camp1)  
    # when /edit inactive camp's\s?page/
    #   edit_camp_path(@camp3)   
    # when /the new camp\s?page/
    #   new_camp_path
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)