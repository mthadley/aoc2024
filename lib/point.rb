class Point < Data.define(:x, :y)
  def self.origin = self[0, 0]

  CARDINALS = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze
  private_constant :CARDINALS

  ORDINALS = [[1, 1], [-1, 1], [1, -1], [-1, -1]].freeze
  private_constant :ORDINALS

  def self.cardinals  = CARDINALS.map { new(*it) }
  def self.ordinals   = ORDINALS.map { new(*it) }
  def self.principals = cardinals + ordinals

  %w[+ - * /].each do |op|
    # `eval` used over `define_method` for speed
    eval <<~RUBY
      def #{op}(other)
        other = other.to_point
        self.class[x #{op} other.x, y #{op} other.y]
      end
    RUBY
  end

  def distance(other) = Math.sqrt((other.x - x) ** 2 + (other.y - y) ** 2)

  def cardinals = self.class.cardinals.map { it + self }
  def ordinals = self.class.ordinals.map { it + self }
  def principals = cardinals + ordinals

  def inspect = "(#{x.inspect}, #{y.inspect})"

  def to_point = self
end

class Numeric
  def to_point = Point[self, self]
end
