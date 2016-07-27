class Post

  attr_reader :title, :comments, :item_id, :points, :url

  def initialize(url)
    @url = url
    @doc = parse_html(url)
    @title = extract_title
    @points = extract_points
    @item_id = extract_item_id
    @comments = []
    extract_comment
  end

  # TODO change to get from url later
  # It only get from local html file for now
  def parse_html(url)
    Nokogiri::HTML(open(url).read)
  end

  def add_comment(comment)
    @comments << comment
  end

  private

  def extract_points
    matches = get_inner_text('span.score')[0].match(/\d+/)
    nil_array_guard(matches).to_i
  end

  def extract_comment
    comment = get_inner_text('tr.comtr span.comment > span')
    user = get_inner_text('tr.comtr span.comhead > a.hnuser:first-child')
    age = get_inner_text('tr.comtr span.comhead > span.age > a:first-child')
    range = (0...[comment.size, user.size, age.size].max)
    range.each do |i|
      add_comment(Comment.new(User.new(user[i]), age[i], comment[i].strip))
    end
  end

  def extract_title
    get_inner_text('td.title > a:first-child')[0]
  end

  def get_inner_text(string)
    @doc.search(string).map do |element|
      element.inner_text
    end
  end

  def extract_item_id
    matches = url.match(/(?<=item\?id=)(\d+)$/)
    nil_array_guard(matches).to_i
  end

  def nil_array_guard(array)
    array.nil? ? nil : array[0]
  end
end 