local util = require('luasnip-util')

return {

  s({
    trig = 'test',
    name = 'test',
    dscr = 'Create a test module',
  }, fmta([[
    #[cfg(test)]
    mod tests {
        use super::*;

        #[test]
        fn test1() {
            assert_eq!(1, 1);
        }
    }
    ]], {
  })
  ),

}
