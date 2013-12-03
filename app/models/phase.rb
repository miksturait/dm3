class Phase < Work::Unit
  alias_method :project, :parent
  alias_method :units, :children

  before_validation :check_inclusion
  validates :wuid,
            inclusion: {
                in: [],
                allow_nil: true,
                message: 'should be unset'
            }

  scope :without_object, ->(object) do
    where(["#{self.table_name}.id != ?", object.id]) unless object.new_record?
  end
  scope :overlapping_with, ->(range) { where(["period && daterange(?,?)", range.begin.to_s, range.end.to_s]) }

  def inclusive?
    period &&
        self.class.
            without_object(self).
            where(ancestry: ancestry).
            overlapping_with(period).exists?
  end

  private

  def check_inclusion
    errors[:period] << "overlaps already created record" if inclusive?
  end
end