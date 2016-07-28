class Post

  EXPECTED_SITES = {
    ycombinator: {
      url: "https://news.ycombinator.com/",
      comment_text: "tr.comtr span.comment span",
      comment_user: "tr.comtr span.comhead > a.hnuser:first-child",
      comment_age: "tr.comtr span.comhead > span.age > a:first-child",
      title: "td.title > a:first-child",
      remove: "tr.comtr span.comment span > div",
      item_id: "(?<=item\\?id=)(\\d+)$"
      }, 
    echojs: {
      url: "http://www.echojs.com/news/", 
      comment_text: "article.comment > pre",
      comment_user: "article.comment span.username > a:first-child",
      comment_age: "article.comment span.info",
      title: "section#newslist > article > h2 > a", 
      remove: "",
      item_id: "(\\d+)$"
      },
    rubyreddit:{
      url: "https://www.reddit.com/r/ruby/", 
      comment_text: "div.entry > form",
      comment_user: "div.entry > p.tagline > a.author",
      comment_age: "div.entry > p.tagline > time",
      title: "p.title > a:first-child",
      remote: "",
      item_id: "(?<=comments\\/)(.*)(?=\\/\\w)"
      },
    imgur: {
      url: "http://imgur.com/gallery/",
      comment_text: "div.comment div.usertext > span",
      comment_user: "div.comment div.usertext > div.author > a:first-child",
      comment_age: "div.comment div.usertext > div.author > a:nth-child(2)",
      title: "div > h1.post-title",
      remove: "",
      item_id: "(?<=item\\?id=)(\\d+)$"
      }
  }

  attr_reader :title, :comments, :item_id, :points, :url

  def initialize(url)
    @url = url
    @site = detect_sites(url)[0]
    @doc = parse_html(url)
    @title = extract_title
    @points = extract_points
    @item_id = extract_item_id
    @comments = []
    extract_comment
  end



  private

  def detect_sites(url)
    EXPECTED_SITES.keys.select do |key|
       !url.match(/^#{EXPECTED_SITES[key][:url]}/).nil?
    end
  end

  def parse_html(url)
    doc = Nokogiri::HTML(open(url).read)

    ###http://www.echojs.com/news/19770
    #doc = Nokogiri::HTML(open("./echojs.html").read)

    #https://news.ycombinator.com/item?id=7663775
    #doc = Nokogiri::HTML(open("./post.html").read)

    #https://www.reddit.com/r/ruby/comments/4sgzh9/avoid_cascading_failures/?st=ir5idj2c&sh=a4fcad48
    #doc = Nokogiri::HTML(open("./reddit.html").read)

    #http://imgur.com/gallery/5VrFZhT
    #doc = Nokogiri::HTML(File.open("./imgur.html").read)
    unless EXPECTED_SITES[@site][:remove] == ""
      doc.search(EXPECTED_SITES[@site][:remove]).each do |element|
        element.remove
      end
    end
    doc
  end

  def add_comment(comment)
    @comments << comment
  end

  def extract_points
    matches = get_inner_text('span.score')
    nil_array_guard(matches)
  end

  def extract_comment
    #binding.pry
    comment = get_inner_text(EXPECTED_SITES[@site][:comment_text])
    user = get_inner_text(EXPECTED_SITES[@site][:comment_user])
    age = get_inner_text(EXPECTED_SITES[@site][:comment_age])
    range = (0...[comment.size, user.size, age.size].max)
    range.each do |i|
      add_comment(Comment.new(User.new(user[i]), age[i], comment[i]))
    end
  end

  def extract_title
    get_inner_text(EXPECTED_SITES[@site][:title])[0]
  end

  def get_inner_text(css)
    @doc.search(css).map do |element|
      element.inner_text.strip
    end
  end

  def extract_item_id
    matches = url.match(/#{EXPECTED_SITES[@site][:item_id]}/)
    nil_array_guard(matches)
  end

  def nil_array_guard(array)
    array.nil? ? nil : array[0]
  end
end 