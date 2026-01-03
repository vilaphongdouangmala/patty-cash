import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Plus, X, Users, AlertCircle } from 'lucide-react'

interface ParticipantsStepProps {
  participants: string[]
  onParticipantsChange: (participants: string[]) => void
}

export function ParticipantsStep({
  participants,
  onParticipantsChange,
}: ParticipantsStepProps) {
  const { t } = useTranslation()
  const [name, setName] = useState('')
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
    onParticipantsChange([...participants, cleanedName])
    setName('')
    setError('')
  }

  const handleRemoveName = (nameToRemove: string) => {
    onParticipantsChange(
      participants.filter((name) => name !== nameToRemove)
    )
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

  return (
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
              error ? 'border-destructive focus:border-destructive' : ''
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
                onClick={() => onParticipantsChange([])}
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
  )
}
