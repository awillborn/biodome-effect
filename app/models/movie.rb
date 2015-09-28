class Movie < ActiveRecord::Base
  scope :biodome_positive, -> { where(biodome: true) }
  RATINGS_CATEGORIES = {
    'male'            => 'men',
    'female'          => 'women',
    'under_18'        => 'all people under 18',
    'male_under_18'   => 'men under 18',
    'female_under_18' => 'women under 18',
    '18_29'           => 'all people ages 18 to 29',
    'male_18_29'      => 'men ages 18 to 29',
    'female_18_29'    => 'women ages 18 to 29',
    '30_44'           => 'all people ages 30 to 44',
    'male_30_44'      => 'men ages 30 to 44',
    'female_30_44'    => 'women ages 30 to 44',
    '45'              => 'all people ages 45 and up',
    'female_45'       => 'women ages 45 and up',
    'male_45'         => 'men ages 45 and up',
    'us'              => 'people from the United States',
    'non_us'          => 'people from outside the United States'
  }

  def get_biodome_effects
    effects = []
    RATINGS_CATEGORIES.keys.each do |cat|
      effects << RATINGS_CATEGORIES[cat] if biodome_effect(cat)
    end
    effects
  end

  def biodome_effect(category)
    ratings = self.send("ratings_#{category}")
    return false unless ratings
    ten = ratings.first
    one = ratings.last
    ratings.each_with_index do |rating, idx|
      next if idx == 0 || idx == 9
      return false if rating.to_i > ten.to_i || rating.to_i > one.to_i
    end
    true
  end
end