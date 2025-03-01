<<<<<<<
local function test_function()
  print("Testing plan mode - MODIFIED")
  return true
end

-- Function has been called and result saved
local result = test_function()
=======
-- Test function with documentation
---@param message string Optional custom message
---@return boolean Always returns true
local function test_function(message)
  print(message or "Testing plan mode - MODIFIED")
  return true
end

-- Secondary utility function
local function another_function()
  return "Another test"
end

-- Function has been called and result saved
local result = test_function()
local another_result = another_function()
>>>>>>>
