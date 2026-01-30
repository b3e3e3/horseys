"use client";

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

import * as Horsey from "../schemas/horsey.schema.json";
import * as Skill from "../schemas/skill.schema.json";

import Form from "@rjsf/shadcn";
import { RJSFSchema } from "@rjsf/utils";
import validator from "@rjsf/validator-ajv8";

const schema: RJSFSchema = Horsey as RJSFSchema;

export default function Home() {
  return (
    <div>
      <Tabs defaultValue="0">
        <TabsList>
          <TabsTrigger value="0">Wild Horsey 1</TabsTrigger>
          <TabsTrigger value="1">Wild Horsey 2</TabsTrigger>
        </TabsList>
        <TabsContent value="0">
          <Form
            schema={schema}
            validator={validator}
            onChange={() => console.log("changed")}
            onSubmit={() => console.log("submitted")}
            onError={() => console.log("errors")}
          />
        </TabsContent>
        <TabsContent value="1"></TabsContent>
      </Tabs>
    </div>
  );
}
