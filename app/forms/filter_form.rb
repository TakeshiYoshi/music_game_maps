class FilterForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :number_of_searches, :integer

  attr_accessor :games

  def session_hash
    return false if invalid?

    hash = {}
    hash[:number_of_searches] = number_of_searches

    # ゲーム機種追加
    hash[:games] = if games.present?
                     games.transform_values { |v| v == 'true' }
                   else
                     {}
                   end

    hash
  end
end
