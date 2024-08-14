-- Russian Translation by StingerSoft (Eritnull aka Шептун)
local L = LibStub("AceLocale-3.0"):NewLocale("GuildCheck", "ruRU", false)

if not L then return end

-- Options
L["Use GUI"] = "Интерфейс"
L["Defines whether the changes are diplayed in the chat or in the GUI on login."] = "Отоброжать изменения в окне чата или в ГИП при входе в игровой мир."
L["Output/Display only on changes"] = "Вывод/Отображение только при изминениях"
L["Show Text/GUI only if changes occurred."] = "Показ текста/Интерфейс только при изменениях"
L["Delay"] = "Задержка"
L["Defines the seconds after login until the changes are reported."] = "Задержка в секундах по истечению которых после входа в игру будет выведен отчёт по изменениям."
L["<Seconds>"] = "<Секунды>"
L["Show GUI"] = "Показать ГИП"
L["Shows a frame where you can display and copy changes."] = "Показать фрейм где вы можете просматреть и скопировать изменения."
L["Show Offline Changes"] = "Показ в не сетевые изменения"
L["Offline"] = "В не сети"
L["Shows changes since last session."] = "Показать изменения с последней сессии."
L["Show Online Changes"] = "Показ сетевые изменения"
L["Online"] = "В сети"
L["Shows changes during this session."] = "Показать изменения во время текущей сессии."
L["Open Config"] = "Открыть настройки"
L["Opens a graphical configuration."] = "Открыть графический настройки"
L["Exit"] = "Выход"
L["Shows changes in your guild since your last time online."] = "Показать изменения в вашей гильдии с прошлого вашего визита."
L["Display"] = "Отаброжение"
L["Defines what kind of changes will be shown."] = ""
L["Show Promotes/Demotes"] = "Показ повышений/понижений"
L["Show Level Ups"] = "Показ изменение уровней"
L["Show Note Changes"] = "Показ изменений заметок"
L["Show Officernote Changes"] = "Показ изменений оффиц.заметок"
L["Members join"] = "Вступление"
L["Show if someone has joined the guild."] = "Показать если кто то вступил в гильдию"
L["Members leave"] = "Выход"
L["Show if someone has left the guild."] = "Показать если кто то вышел из гильдии"
L["Use Guild Log"] = "Исп. журнал гильдии"
L["Use Data from the Guild Log to show who has invited, promoted, demoted or kicked players.\n\n|cffff0000The output can lag a bit.|r"] = "Использовать данные из журнала гильдии для отображения кто вступил,повысил,понизил или исключил игроков.\n\n|cffff0000Вывод может вызвать легкое торможение.|r"
L["Change Output Channel to Whisper"] = ""
L["Defines whether the changes are diplayed in the default Chat or Whisper to Player."] = ""   
L["Minimap Button"] = ""
L["Hides Minimap Button."] = ""
    
-- Output
L["has left the guild"] = "вышел из гильдии"
L["was removed by %s"] = "удалён %s"
L["has joined the guild"] = "вступил в гильдию"
L["has joined the guild (invited by %s)"] = "вступил в гильдию (принел %s)"
L["was promoted by %s"] = "повысил %s"
L["was demoted by %s"] = "понизил %s"
L["Rank"] = "Ранг"
L["Level"] = "Уровень"
L["Class"] = "Класс"
L["Note"] = "Заметка"
L["Officernote"] = "Офицерская заметка"
L["Initial scan done."] = "Сканирование завершено."
L["The guild '%s' has been deleted."] = "Гильдия '%s' удалина."
L["Total: %d changes"] = "Всего: %d изменений"
L["Total: 1 change"] = "Всего: 1 изменение"
L["no changes found"] = "изменений не найдено"

--[[ Needs translation:
L["Data upgraded to version %s!"] = 
--]]

-- Dialog
L["It seems that your last character has left this guild.\nDo you want to delete the data that GuildCheck has saved for this guild?"] = "Кажится ваш персонаж покинул гильдию.\nВы хотите удалить сохраненные данные GuildCheckа для данной гильдии ?"
L["Your GuildCheck Data needs a conversion! This process is not reversible.\nYou can choose 'No' and backup your SavedVariables folder.\nGuildCheck won't work as long as you don't convert the data.\n\nDo you want to convert the data now?"] = "Ваши данные GuildCheck нуждаются в преобразовании! Этот процесс не обратим.\nВы можете выбрать 'Нет' и зделать резервную копию вашей папки SavedVariables.\nGuildCheck не будет работать если вы не сконвертируете данные.\n\nВы хотите преобразовать данные сейчас?"
L["Yes"] = "Да"
L["No"] = "Нет"