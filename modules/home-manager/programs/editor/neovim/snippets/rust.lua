---@diagnostic disable: undefined-global

return {
  s(
    {
      trig = 'test',
      name = 'test',
      desc = 'test module',
    },
    fmta(
      [[
      #[cfg(test)]
      mod tests {
          use super::*;

          #[test]
          fn <>() {
              <>
          }
      }
      ]],
      { i(1, 'testname'), i(2, 'assert_eq!(1 + 1, 2);') }
    )
  ),
}
