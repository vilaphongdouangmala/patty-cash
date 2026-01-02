import * as z from 'zod'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { BillSplitingStep } from '@/lib/bill-spliting/enums'
import { createFileRoute } from '@tanstack/react-router'
import {
  Plus,
  X,
  Users,
  AlertCircle,
  Trash,
  ReceiptText,
  Receipt,
} from 'lucide-react'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useFieldArray, useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { Form, FormControl, FormField, FormItem } from '@/components/ui/form'

export const Route = createFileRoute('/')({
  component: App,
})

function App() {
  const { t } = useTranslation()

  // Participants Step
  const [name, setName] = useState('')
  const [participants, setParticipants] = useState<string[]>([])
  const [error, setError] = useState('')

  const handleAddName = () => {
    const cleanedName = name.trim()
    if (!cleanedName) return
    if (
      participants.some((p) => p.toLowerCase() === cleanedName.toLowerCase())
    ) {
      setError(t('participants.duplicateError'))
      return
    }
    setParticipants((prev) => [...prev, cleanedName])
    setName('')
    setError('')
  }

  const handleRemoveName = (nameToRemove: string) => {
    setParticipants((prev) => prev.filter((name) => name !== nameToRemove))
  }

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleAddName()
    }
  }

  const handleInputChange = (value: string) => {
    setName(value)
    if (error) setError('')
  }

  // Items Step
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

  function onSubmitBillForm() {
    console.log('onSubmitBillForm')
  }

  return (
    <div className="min-h-screen bg-linear-to-br from-background to-muted/20">
      <div className="container mx-auto px-4 py-16">
        <div className="max-w-md mx-auto">
          <div className="text-center mb-8">
            <div className="inline-flex items-center justify-center w-16 h-16 bg-primary/10 rounded-full mb-4 text-2xl font-bold">
              1
            </div>
            <div className="flex items-center justify-center gap-4 mb-4">
              <h1 className="text-2xl font-bold text-foreground">
                {t('participants.title')}
              </h1>
            </div>
          </div>
          <div className="bg-card border rounded-xl shadow-sm p-4">
            <Tabs defaultValue={BillSplitingStep.Participants}>
              <TabsList className="mb-4 w-full">
                <TabsTrigger
                  className="w-full py-4"
                  value={BillSplitingStep.Participants}
                >
                  <Users />
                </TabsTrigger>
                <TabsTrigger
                  className="w-full py-4"
                  value={BillSplitingStep.BillItems}
                >
                  <ReceiptText />
                </TabsTrigger>
                <TabsTrigger
                  className="w-full py-4"
                  value={BillSplitingStep.Summary}
                >
                  <Receipt />
                </TabsTrigger>
              </TabsList>
              <TabsContent value={BillSplitingStep.Participants}>
                <div className="space-y-4">
                  <div className="flex flex-col gap-2">
                    <label
                      htmlFor="name-input"
                      className="text-sm font-medium text-foreground"
                    >
                      {t('participants.participant')}
                    </label>
                    <div className="flex w-full max-w-sm items-center gap-2">
                      <Input
                        id="name-input"
                        placeholder={t('participants.namePlaceholder')}
                        value={name}
                        onChange={(e) => handleInputChange(e.target.value)}
                        className={`flex-1 ${
                          error
                            ? 'border-destructive focus:border-destructive'
                            : ''
                        }`}
                        onKeyUp={handleKeyPress}
                        aria-invalid={error ? 'true' : 'false'}
                        aria-describedby={error ? 'error-message' : undefined}
                      />
                      <Button
                        onClick={handleAddName}
                        disabled={!name.trim()}
                        size="default"
                        className="px-4 h-12.5 w-12.5"
                      >
                        <Plus />
                      </Button>
                    </div>
                    {error && (
                      <div
                        id="error-message"
                        className="flex items-center gap-2 text-sm text-destructive"
                        role="alert"
                      >
                        <AlertCircle className="w-4 h-4" />
                        <span>{error}</span>
                      </div>
                    )}
                  </div>

                  {participants.length > 0 && (
                    <div className="space-y-3">
                      <div className="flex items-center justify-between">
                        <h3 className="text-sm font-medium text-foreground">
                          {t('participants.addedNames')} ({participants.length})
                        </h3>
                        {participants.length > 1 && (
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => setParticipants([])}
                            className="text-muted-foreground hover:text-destructive"
                          >
                            {t('participants.clearAll')}
                          </Button>
                        )}
                      </div>
                      <div className="space-y-2">
                        {participants.map((participant, index) => (
                          <div
                            key={index}
                            className="flex items-center justify-between p-3 bg-muted/50 rounded-lg border border-border/50 hover:bg-muted transition-colors"
                          >
                            <span className="font-medium text-foreground">
                              {participant}
                            </span>
                            <Button
                              variant="ghost"
                              size="icon-sm"
                              onClick={() => handleRemoveName(participant)}
                              className="text-muted-foreground hover:text-destructive hover:bg-destructive/10"
                            >
                              <X className="w-4 h-4" />
                            </Button>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  {participants.length === 0 && (
                    <div className="text-center py-8 text-muted-foreground">
                      <Users className="w-12 h-12 mx-auto mb-3 opacity-50" />
                      <p className="text-sm">{t('participants.emptyState')}</p>
                    </div>
                  )}
                </div>
              </TabsContent>
              <TabsContent value={BillSplitingStep.BillItems}>
                <Form {...billForm}>
                  <form
                    onSubmit={billForm.handleSubmit(onSubmitBillForm)}
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
                                  <Input
                                    placeholder="e.g. Pizza"
                                    {...fieldProps}
                                  />
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

                        <Button
                          type="button"
                          variant="ghost"
                          onClick={() => remove(index)}
                        >
                          <Trash className="text-muted-foreground" />
                        </Button>
                      </div>
                    ))}

                    <Button
                      className="w-full py-6 my-2 mb-6 border border-dashed text-muted-foreground"
                      type="button"
                      variant="outline"
                      onClick={() =>
                        append({ name: '', price: 0, participants: [] })
                      }
                    >
                      <Plus className="w-4 h-4 mr-2" />
                      Add Item
                    </Button>

                    <Button type="submit" className="w-full">
                      Continue to Summary
                    </Button>
                  </form>
                </Form>
              </TabsContent>
              <TabsContent value={BillSplitingStep.Summary}>
                Add your summary here
              </TabsContent>
            </Tabs>
          </div>
        </div>
      </div>
    </div>
  )
}
