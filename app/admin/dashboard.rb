ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #

    columns do
      column do 
        panel "Statistic New Users" do
          tabs do
            tab :date do
              column_chart User.all.group_by{|x| x.created_at.localtime.to_date.to_s(:db)}.map {|k,v| [k, v.length]}.sort
            end
            tab :month do
              column_chart User.all.group_by{|x| x.created_at.localtime.beginning_of_month.strftime("%Y-%m")}.map {|k,v| [k, v.length]}.sort
            end
            tab :year do
              column_chart User.all.group_by{|x| x.created_at.localtime.year.to_s(:db)}.map {|k,v| [k, v.length]}.sort
            end
          end
        end
      end
      column do
        panel "Statistic Recipes" do
          # pie_chart Recipe.group(:published).count.map {|k,v| [k ? "Published" : "Pending", v]}
          tabs do
            tab :date do
              column_chart Recipe.all.group_by{|x| x.created_at.localtime.to_date.to_s(:db)}.map {|k,v| [k, v.length]}.sort
            end
            tab :month do
              column_chart Recipe.all.group_by{|x| x.created_at.localtime.beginning_of_month.strftime("%Y-%m")}.map {|k,v| [k, v.length]}.sort
            end
            tab :year do
              column_chart Recipe.all.group_by{|x| x.created_at.localtime.year.to_s(:db)}.map {|k,v| [k, v.length]}.sort
            end
          end
        end
      end
    end
    
    columns do
      column do
        panel "New Users in 24h (#{User.where(created_at: (1.day.ago..Time.zone.now)).size})" do
          table_for User.where(created_at: (1.day.ago..Time.zone.now)).order(created_at: :desc).take(10).map do
            column :full_name do |user|
              link_to(user.full_name, admin_user_path(user))
            end
            column :created_at do |x|
              p x.created_at.localtime
            end
          end
          strong { link_to "View All Users", admin_users_path }
        end
      end

      column do
        panel "Pending Recipes (#{Recipe.unpublished.size})" do
          table_for Recipe.unpublished.order(created_at: :desc).limit(5) do
            column :title do |recipe|
              link_to recipe.title, admin_recipe_path(recipe)
            end
            column :created_at do |x|
              p x.created_at.localtime
            end
          end
          strong { link_to "View All Pending Recipes", admin_recipes_path }
        end
      end
    end
    
  end # content
end
