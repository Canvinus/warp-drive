import '@fontsource/space-grotesk'

import { extendTheme } from '@chakra-ui/react'

const theme = extendTheme({
  fonts: {
    heading: 'Space Grotesk',
    body: 'Space Grotesk',
  },
  colors: {
    offWhite: '#FFFFE0',
    silver: '#C0C0C0',
  },
  styles: {
    global: {
      body: {
        bg: 'black',
      },
    },
  },
})

export { theme }
