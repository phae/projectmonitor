class CircleCiPayload < Payload

  def building?
    status_content.first['status'] == 'running' || status_content.first['status'] == 'queued'
  end

  def content_ready?(content)
    content['status'] != 'running' && content['status'] != 'queued'
  end

  def convert_content!(content)
    json = JSON.parse(content)
    Array.wrap(json)
  rescue => e
    self.processable = self.build_processable = false
    raise Payload::InvalidContentException, e.message
  end

  def parse_success(content)
    content['outcome'] == 'success'
  end

  def parse_url(content)
    self.parsed_url = content['build_url'].split('builds').first
    content['build_url']
  end

  def parse_build_id(content)
    content['build_num']
  end

  def parse_published_at(content)
    if content['stop_time']
      Time.parse(content['stop_time'])
    else
      Time.now
    end
  end

end
