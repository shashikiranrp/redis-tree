-- DFS walker for Tree model in REDIS
-- Model: 
--  Node: {
--          "children" : "<children_list_or_set_key_name>"
--          "data" : "<data_list_or_set_key_name>"
--        }
--  children_list_or_set_key_name: SET
--  data_list_or_set_key_name: SET

local START = 0
local ENDI = 0
local EXIT_NOW = false

local REDIS_SET_MEMBERS_CMD = "SMEMBERS"
local REDIS_SET_CARD_CMD = "SCARD"
local REDIS_HGET_CMD = "HGET"

local function get_children(node_key)
  local child_key = redis.call(REDIS_HGET_CMD, node_key, 'children')
  if child_key 
    then
      return redis.call(REDIS_SET_MEMBERS_CMD, child_key)
    end
end

local function get_data(node_key)
  local data_key = redis.call(REDIS_HGET_CMD, node_key, 'data')
  if data_key
    then
      return redis.call(REDIS_SET_MEMBERS_CMD, data_key)
    end
end

local function get_data_size(node_key)
  local data_key = redis.call(REDIS_HGET_CMD, node_key, 'data')
  if data_key
    then
      return redis.call(REDIS_SET_CARD_CMD, data_key)
    end
end

local function dfs_page(nodes, key) 
  local data_size = get_data_size(key)
  if START > data_size
    then
      -- Not present in current window
      START = START - data_size
  else
    -- If present then get the data
    local data = get_data(key)
    if data
      then
        for _, val in pairs(data) do
          if START == 0 
            then
              if #nodes == ENDI
                then
                -- Announce to break the search
                  EXIT_NOW = true
                  return
                end

              -- Insert to page
              table.insert(nodes, val)
          else
           -- Not yet reached the start of the page
              START = START - 1
            end
        end
      end
    end

  local children = get_children(key)
  if children
    then
      for _, val in pairs(children) do
        -- Break when you get the page
        if EXIT_NOW
          then
            return
          end
        dfs_page(nodes, val)
      end
    end
end

local function main(root_node, start, endi)
  local nodes = {}
  START = tonumber(start)
  ENDI = tonumber(endi)
  dfs_page(nodes, root_node)
  return nodes
end

-- root_node, start, count
return main(ARGV[1], ARGV[2], ARGV[3])
