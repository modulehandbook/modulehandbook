require 'minitest/autorun'

# https://github.com/vmg/redcarpet
# https://www.rubydoc.info/gems/redcarpet/3.5.0/Redcarpet/Render/HTML#initialize-instance_method

class TryoutRedcarpet < Minitest::Test
  def setup
    html_renderer = Redcarpet::Render::HTML.new
    @markdown = Redcarpet::Markdown.new(html_renderer, {})
  end

  def test_paragraph
    assert_equal "<p>This is a paragraph</p>\n", @markdown.render('This is a paragraph')
  end

  def test_header
    assert_equal "<h1>This is a header</h1>\n", @markdown.render('# This is a header')
  end

  def test_italics
    assert_equal "<p>an <em>italics</em> example</p>\n", @markdown.render('an _italics_ example')
  end

  def test_bold
    assert_equal "<p>an <strong>bold</strong> example</p>\n", @markdown.render('an **bold** example')
  end

  def test_bold_and_italics
    assert_equal "<p>an <strong><em>italics and bold</em></strong> example</p>\n",
                 @markdown.render('an **_italics and bold_** example')
  end

  def test_links
    assert_equal "<p>Links: <a href=\"https://bkleinen.github.io\">https://bkleinen.github.io</a></p>\n",
                 @markdown.render('Links: [https://bkleinen.github.io](https://bkleinen.github.io)')
  end

  def test_blockquotes
    html = <<~DELIM
      <blockquote>
      <p>Blockquotes are also possible</p>
      </blockquote>
    DELIM
    assert_equal html, @markdown.render('> Blockquotes are also possible')
  end

  def test_list
    md = <<~DELIM
      * eins
      * zwei
      * drei
    DELIM
    html = <<~DELIM
      <ul>
      <li>eins</li>
      <li>zwei</li>
      <li>drei</li>
      </ul>
    DELIM
    assert_equal html, @markdown.render(md)
  end

  def test_paragraphs
    md = <<~DELIM
      Und wieder wecken mich Berliner Spatzen!
      Ich liebe diesen märkisch-kessen Ton.
      Hör ich sie morgens an mein Fenster kratzen,
      Am Ku-Damm in der Gartenhauspension,
      Komm ich beglückt, nach alter Tradition,
      Ganz so wie damals mit besagten Spatzen
      Mein Tagespensum durchzuschwatzen.

      Es ostert schon. Grün treibt die Zimmerlinde.
      Wies heut im Grunewald nach Frühjahr roch!
      Ein erster Specht beklopft die Birkenrinde.
      Nun pfeift der Ostwind aus dem letzten Loch.
      Und alles fragt, wie ich Berlin denn finde?
      – Wie ich es finde? Ach, ich such es noch!
    DELIM
    html = <<~DELIM
      <p>Und wieder wecken mich Berliner Spatzen!
      Ich liebe diesen märkisch-kessen Ton.
      Hör ich sie morgens an mein Fenster kratzen,
      Am Ku-Damm in der Gartenhauspension,
      Komm ich beglückt, nach alter Tradition,
      Ganz so wie damals mit besagten Spatzen
      Mein Tagespensum durchzuschwatzen.</p>

      <p>Es ostert schon. Grün treibt die Zimmerlinde.
      Wies heut im Grunewald nach Frühjahr roch!
      Ein erster Specht beklopft die Birkenrinde.
      Nun pfeift der Ostwind aus dem letzten Loch.
      Und alles fragt, wie ich Berlin denn finde?
      – Wie ich es finde? Ach, ich such es noch!</p>
    DELIM
    assert_equal html, @markdown.render(md)
  end
end
