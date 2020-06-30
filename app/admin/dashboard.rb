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
        panel "Pending Recipes (#{Recipe.unpublished.size})" do
          ul do
            Recipe.unpublished.order(created_at: :desc).take(10).map do |recipe|
              li link_to(recipe.title, admin_recipe_path(recipe))
            end
          end
          a link_to "See more", admin_recipes_path
        end
      end

      column do
        panel "New Users Today (#{User.where(created_at: (1.day.ago..Time.zone.now)).size})" do
          ul do
            User.where(created_at: (1.day.ago..Time.zone.now)).order(created_at: :desc).take(10).map do |user|
              li link_to(user.full_name, admin_user_path(user))
            end
          end
          a link_to "See more", admin_users_path
        end
      end
    end
  end # content
end
