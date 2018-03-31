class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :created_at, :updated_at, :last_login
end
