local helpers = require('tests.helpers')
local clean_buffer = helpers.clean_buffer

require('lean').setup {}

describe('sorry', function()
  it('lean 3: inserts sorries for each remaining goal', clean_buffer("lean3", [[
def foo (n : nat) : n = n := begin
  induction n with d hd,
end]], function()
    vim.api.nvim_command('normal! 3gg$')
    helpers.wait_for_line_diagnostics()

    vim.api.nvim_command('normal! 2gg$')
    require('lean.sorry').fill()
    assert.contents.are[[
def foo (n : nat) : n = n := begin
  induction n with d hd,
  { sorry },
  { sorry },
end]]
  end))

  it('lean 4: inserts sorries for each remaining goal', clean_buffer('lean', [[
example (p q : Prop) : p ∧ q ↔ q ∧ p := by
  constructor]],
  function()
    helpers.wait_for_line_diagnostics()

    vim.api.nvim_command('normal! 2gg$')
    require('lean.sorry').fill()
    assert.contents.are[[
example (p q : Prop) : p ∧ q ↔ q ∧ p := by
  constructor
  · sorry 
  · sorry ]]
  end))
end)
