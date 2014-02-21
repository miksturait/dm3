module Dm2
  class Project < Dm2::Base
    has_many :children, class_name: self, foreign_key: :parent_id

    def descendants
      self.class.where(["lft >= ? AND rgt <= ?", lft, rgt])
    end

    def time_entries
      Dm2::TimeEntry.where("project_id IN (#{descendants.select(:id).to_sql})")
    end

    scope :roots, -> { where(parent_id: nil) }
  end
end
