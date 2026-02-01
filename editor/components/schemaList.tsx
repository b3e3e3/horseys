import {
	Accordion,
	AccordionContent,
	AccordionItem,
	AccordionTrigger,
} from "@/components/ui/accordion"
import { Button } from "@/components/ui/button"
import { useState } from "react"
// import { useState } from "react"

export type FileListItem = {
	value: string
	trigger: string
	files: string[]
}

export function SchemaList(props: {
	items: FileListItem[]
	onFileSelected?: (name: string, from: string) => void
}) {
	const [listItems, setListItems] = useState<FileListItem[]>(props.items)
	return (
		<Accordion type="multiple">
			{listItems.map((item) => (
				<AccordionItem key={item.value} value={item.value}>
					<AccordionTrigger>{item.trigger}</AccordionTrigger>
					<AccordionContent>
						<ul>
							{item.files.map((fileName) => (
								<li key={`${item.value}/${fileName}`}>
									<Button
										variant={"link"}
										className="hover:underline"
										onClick={() =>
											props.onFileSelected?.(
												fileName,
												item.value,
											)
										}
									>
										{fileName}
									</Button>
								</li>
							))}
						</ul>
					</AccordionContent>
				</AccordionItem>
			))}
		</Accordion>
	)
}
