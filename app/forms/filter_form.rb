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
    if games.present?
      hash[:games] = games.transform_values { |v| v == 'true' }
    else
      hash[:games] = {}
    end

    hash
  end
end
