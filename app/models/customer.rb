class Customer < Work::Unit
  alias_method :projects, :children
  alias_method :company, :parent

  after_create :set_api_token

  validates :wuid,
            inclusion: {
                in: [],
                allow_nil: true,
                message: 'should be unset'
            }

  scope :skip_internall, -> { where("NOT opts @> hstore('internall', 'true')")}

  private

  def set_api_token
    update_column(:api_token, "#{SecureRandom.urlsafe_base64}#{id}")
  end

  def children_class
    Project
  end
end
