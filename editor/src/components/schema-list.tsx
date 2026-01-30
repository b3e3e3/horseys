import {
	Accordion,
	AccordionContent,
	AccordionItem,
	AccordionTrigger,
} from "@/components/ui/accordion"

const items = [
	{
		value: "horseys",
		trigger: "Horseys",
		files: ["horsey1.json", "horsey2.json"],
	},
	{
		value: "skills",
		trigger: "Skills",
		files: ["skill1.json", "skill2.json"],
	},
]

export function SchemaList(props: {
	onFileSelected?: (name: string, from: string) => void
}) {
	return (
		<Accordion type="multiple">
			{items.map((item) => (
				<AccordionItem key={item.value} value={item.value}>
					<AccordionTrigger>{item.trigger}</AccordionTrigger>
					<AccordionContent>
						<ul>
							{item.files.map((fileName) => (
								<li key={`${item.value}/${fileName}`}>
									<a
										href="#"
										className="hover:underline"
										onClick={() =>
											props.onFileSelected?.(
												fileName,
												item.value,
											)
										}
									>
										{fileName}
									</a>
								</li>
							))}
						</ul>
					</AccordionContent>
				</AccordionItem>
			))}
		</Accordion>
	)
}
