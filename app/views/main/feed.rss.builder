xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t('rss.title')
    xml.description t('rss.description')
    xml.link root_url

    for node in @nodes
      xml.item do
        xml.title node.title
        xml.description node.summary
        xml.pubDate node.created_at.to_s(:rfc822)
        xml.link node_url(node)
      end
    end
  end
end