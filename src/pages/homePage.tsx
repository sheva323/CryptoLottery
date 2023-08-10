import React from "react";
import Counter from '../components/counter';
import Buy from '../components/buy';
import Projects from '../components/projects';
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
      templateAreas={`"header header"
                  "main main"
                  "footer footer"`}
      gridTemplateRows={'auto 1fr auto'}
      gridTemplateColumns={'150px 1fr'}
      h='200px'
      gap='1'
      color='blackAlpha.700'
      fontWeight='bold'
      maxW='70%'
      margin="0 auto"
    >
      <GridItem pl='2' bg='orange.300' area={'header'}>
        <Counter />
      </GridItem>
      <GridItem pl='2' bg='green.300' area={'main'}>
        <Multistep />
      </GridItem>
      <GridItem pl='2' bg='blue.300' area={'footer'}>
        Footer
      </GridItem>
    </Grid>

  </>
};

export default HomePage;
