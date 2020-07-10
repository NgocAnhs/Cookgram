ActiveAdmin.register User do
  permit_params :email, :fname, :lname, :password, :password_confirmation, :trusted, :admin

  index do
    selectable_column
    id_column
    column :email
    column :fname
    column :lname
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :trusted
    column :admin
    actions
  end

  filter :email
  filter :trusted
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :fname
      f.input :lname
      f.input :password
      f.input :password_confirmation
      f.input :trusted, :label => "Trusted"
      f.input :admin, :label => "Administrator"
    end
    f.actions
  end

end
