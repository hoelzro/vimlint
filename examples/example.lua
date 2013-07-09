function activate(config)
  local severity = config.severity or 5
  return severity > 3
end

-- alternatively, the Lua plugin loader could handle the severity key specially...
severity = 3

function lint(parse_tree)
  -- XXX check the parse tree here
end
