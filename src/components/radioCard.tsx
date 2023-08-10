import {
  useRadio, Box, Text, Heading, Avatar,
  useColorModeValue,
} from "@chakra-ui/react";


export default function RadioCard(props: any) {
  const { getInputProps, getRadioProps } = useRadio(props)

  const input = getInputProps()
  const checkbox = getRadioProps()

  return (
    <Box as='label'>
      <input {...input} />
      <Box
        {...checkbox}
        cursor='pointer'
        borderWidth='1px'
        borderRadius='md'
        boxShadow='md'
        _checked={{
          borderColor: 'teal.500',
          borderWidth: '2px'
        }}
        _focus={{
          boxShadow: 'outline',
        }}
        px={5}
        py={3}
      >
        <Avatar
          size={'xl'}
          src={
            'https://images.unsplash.com/photo-1520810627419-35e362c5dc07?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ'
          }
          mb={3}
          pos={'relative'}
        />
        <Heading fontSize={'xl'} fontFamily={'body'}>
          {props.children}
        </Heading>
        <Text fontWeight={300} color='gray.500' mb={2}>
          102 votes
        </Text>
        <Text
          textAlign={'center'}
          color={useColorModeValue('gray.700', 'gray.400')}
          px={3}>
          0x774..F88b8
        </Text>
      </Box>
    </Box>
  )
}