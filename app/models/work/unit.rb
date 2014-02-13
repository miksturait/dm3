class Work::Unit < ActiveRecord::Base
  self.table_name = 'work_units'
  has_ancestry cache_depth: true
  has_many :time_entries, class_name: Work::TimeEntry
  has_many :coworker_targets, class_name: Work::CoworkerTarget

  validates :wuid, presence: true, if: Proc.new { |work_unit| work_unit.type.blank? }
  validates :wuid,
            uniqueness: {
                scope: :ancestry,
                allow_nil: true
            }

  scope :skip_archived, -> { where("opts @> hstore('archived', 'false')") }

  delegate :begin, :end,
           to: :period,
           prefix: true, allow_nil: true


  def time_entries
    Work::TimeEntry.where(work_unit_id: subtree_ids)
  end

  def label
    [wuid, name].compact.join(" - ")
  end

  def create_children(attrs={})
    build_children(attrs).tap { |work_unit| work_unit.save }
  end

  def create_children!(attrs={})
    build_children(attrs).tap { |work_unit| work_unit.save! }
  end

  def build_children(attrs={})
    children_class.new(attrs.merge(parent: self))
  end

  private

  def children_class
    Work::Unit
  end
end
