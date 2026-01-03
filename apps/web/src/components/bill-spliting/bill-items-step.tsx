import * as z from 'zod'
import { useTranslation } from 'react-i18next'
import { useFieldArray, useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Form, FormControl, FormField, FormItem } from '@/components/ui/form'
import { Plus, Trash } from 'lucide-react'

interface BillItemsStepProps {
  onSubmit: (items: BillItem[]) => void
}

export interface BillItem {
  name: string
  price: number
  participants: string[]
}

export function BillItemsStep({ onSubmit }: BillItemsStepProps) {
  const { t } = useTranslation()

  const billItemsFormSchema = z.object({
    name: z.string().min(1, t('billItems.nameRequired')),
    price: z.number().min(1, t('billItems.priceRequired')),
    participants: z.array(z.string()),
  })

  const billFormSchema = z.object({
    items: z.array(billItemsFormSchema),
  })

  const billForm = useForm<z.infer<typeof billFormSchema>>({
    resolver: zodResolver(billFormSchema),
    defaultValues: {
      items: [{ name: '', price: 0, participants: [] }],
    },
  })

  const { fields, append, remove } = useFieldArray({
    name: 'items',
    control: billForm.control,
  })

  function handleSubmit(data: z.infer<typeof billFormSchema>) {
    onSubmit(data.items)
  }

  return (
    <Form {...billForm}>
      <form
        onSubmit={billForm.handleSubmit(handleSubmit)}
        className="space-y-4"
      >
        {fields.map((field, index) => (
          <div key={field.id} className="flex items-center gap-2">
            <div className="w-3/5">
              <FormField
                control={billForm.control}
                name={`items.${index}.name`}
                render={({ field: fieldProps }) => (
                  <FormItem>
                    <FormControl>
                      <Input placeholder="e.g. Pizza" {...fieldProps} />
                    </FormControl>
                  </FormItem>
                )}
              />
            </div>
            <div className="w-2/5">
              <FormField
                control={billForm.control}
                name={`items.${index}.price`}
                render={({ field: fieldProps }) => (
                  <FormItem>
                    <FormControl>
                      <Input
                        className="text-right"
                        type="number"
                        placeholder="0.00"
                        {...fieldProps}
                        onChange={(event) =>
                          fieldProps.onChange(+event.target.value)
                        }
                      />
                    </FormControl>
                  </FormItem>
                )}
              />
            </div>

            <Button type="button" variant="ghost" onClick={() => remove(index)}>
              <Trash className="text-muted-foreground" />
            </Button>
          </div>
        ))}

        <Button
          className="w-full py-6 my-2 mb-6 border border-dashed text-muted-foreground"
          type="button"
          variant="outline"
          onClick={() => append({ name: '', price: 0, participants: [] })}
        >
          <Plus className="w-4 h-4 mr-2" />
          {t('billItems.addItem')}
        </Button>

        <Button type="submit" className="w-full">
          {t('billItems.goToSummary')}
        </Button>
      </form>
    </Form>
  )
}
