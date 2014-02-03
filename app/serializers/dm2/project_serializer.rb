class DM2::ProjectSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :name
end
