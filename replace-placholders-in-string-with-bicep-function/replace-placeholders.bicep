@export()
func replacePlaceholders(originalString string, placeholders { *: string }) string =>
  replacePlaceholderInternal(originalString, items(placeholders))

func replacePlaceholderInternal(originalString string, placeholders array) string =>
  reduce(
    placeholders, 
    originalString, // this is the first 'current'
    (current, next) => replacePlaceholder(current, next.key, next.value)
  )

@export()
func replacePlaceholder(originalString string, placeholder string, value string) string =>
  replace(originalString, '$(${placeholder})', value)
