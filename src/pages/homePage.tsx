import React from "react";
import Counter from '../components/counter';
import Buy from '../components/buy';
import Multistep from "../components/Mutistep";

import {
  Flex, Center, Text, Square, Box, Spacer, Heading, HStack, Button, Stack, Avatar, VStack, Input, InputGroup, InputLeftAddon, Badge, Link,
  useColorModeValue, Grid, GridItem
} from '@chakra-ui/react';

const HomePage = () => {
  return <>
    {/* <div>test home</div> */}
    {/*
    <Buy /> */}
    {/* <Projects /> */}
    <Grid
      templateAreas={`"header"
        "main"`}
      gridTemplateRows={'auto 1fr auto'}
      gridTemplateColumns={'1fr'}
      h='200px'
      gap='1'
      color='blackAlpha.700'
      fontWeight='bold'
      maxW='70%'
      margin="0 auto"
    >
      <GridItem area={'header'}>
        <Counter />
      </GridItem>
      <GridItem area={'main'}>
        <Multistep />
      </GridItem>
    </Grid>

  </>
};

export default HomePage;
