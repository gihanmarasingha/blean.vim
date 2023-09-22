local helpers = require('tests.helpers')
local clean_buffer = helpers.clean_buffer

require('lean').setup {}

describe('sorry', function()
  it('inserts sorries for each remaining goal', clean_buffer('lean', [[
import Mathlib.tactic

def foo (n : Nat) : n = n := by
  induction' n with d hd]], function()
    vim.api.nvim_command('normal! 4gg$')
    helpers.wait_for_line_diagnostics()

    vim.api.nvim_command('normal! 2gg$')
    require('lean.sorry').fill()
    assert.contents.are[[
import Mathlib.tactic

def foo (n : Nat) : n = n := by
  induction' n with d hd
  · sorry
  · sorry]]
  end))


end)
