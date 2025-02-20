local snippet = function(prefix, body)
  vim.snippet.add(prefix, body, { buffer = 0 })
end

snippet('de', '#[derive(${1})]')
snippet(
  'test',
  [[#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test() {
        ${0}
    }
}]]
)
