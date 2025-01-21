-- Create events table
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    category VARCHAR(50) NOT NULL,
    genre VARCHAR(50),
    available_tickets INTEGER NOT NULL DEFAULT 100,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create tickets table
CREATE TABLE tickets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID REFERENCES events(id),
    user_id UUID REFERENCES auth.users(id),
    quantity INTEGER NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert festivals
INSERT INTO events (title, description, date, price, image_url, category, genre) VALUES
('Фестиваль красок Холи', 'Яркий индийский праздник весны с музыкой, танцами и красочным порошком.', '2025-06-15 12:00:00+00', 1500.00, 'https://images.unsplash.com/photo-1532634922-8fe0b757fb13?q=80&w=800', 'festival', 'cultural'),
('Фестиваль уличной еды', 'Гастрономический праздник с лучшими фуд-траками и поп-ап ресторанами города.', '2025-07-20 11:00:00+00', 2000.00, 'https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?q=80&w=800', 'festival', 'food'),
('Фестиваль воздушных шаров', 'Красочное шоу воздушных шаров с возможностью полета и фотосессией на закате.', '2025-08-10 16:00:00+00', 3500.00, 'https://images.unsplash.com/photo-1507608616759-54f48f0af0ee?q=80&w=800', 'festival', 'entertainment'),
('Фестиваль современного искусства', 'Выставки, инсталляции и перформансы от современных художников.', '2025-09-05 10:00:00+00', 1800.00, 'https://images.unsplash.com/photo-1515634928627-2a4e0dae3ddf?q=80&w=800', 'festival', 'art'),
('Фестиваль света', 'Впечатляющие световые инсталляции и 3D-маппинг на исторических зданиях.', '2025-10-20 19:00:00+00', 2200.00, 'https://images.unsplash.com/photo-1507919909716-c8262e491cde?q=80&w=800', 'festival', 'art'),
('Фестиваль этнической музыки', 'Музыкальный фестиваль с участием коллективов со всего мира.', '2025-07-25 15:00:00+00', 2800.00, 'https://images.unsplash.com/photo-1511192336575-5a79af67a629?q=80&w=800', 'festival', 'music'),
('Фестиваль японской культуры', 'Погружение в японскую культуру: чайные церемонии, боевые искусства и косплей.', '2025-08-30 11:00:00+00', 2500.00, 'https://images.unsplash.com/photo-1492571350019-22de08371fd3?q=80&w=800', 'festival', 'cultural'),
('Фестиваль науки', 'Интерактивные научные эксперименты и лекции от ведущих учёных.', '2025-09-15 10:00:00+00', 1500.00, 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?q=80&w=800', 'festival', 'education'),
('Фестиваль кино под открытым небом', 'Показы лучших фильмов года под звездным небом.', '2025-07-10 21:00:00+00', 1200.00, 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=800', 'festival', 'cinema'),
('Фестиваль экстремальных видов спорта', 'Соревнования по скейтбордингу, BMX и паркуру.', '2025-08-05 12:00:00+00', 2000.00, 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?q=80&w=800', 'festival', 'sport');

-- Insert retreats
INSERT INTO events (title, description, date, price, image_url, category, genre) VALUES
('Йога-ретрит в горах', 'Неделя йоги, медитации и духовных практик в горном retreat-центре.', '2025-06-20 08:00:00+00', 45000.00, 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=800', 'retreat', 'yoga'),
('Детокс-ретрит', 'Программа очищения организма с правильным питанием и spa-процедурами.', '2025-07-01 09:00:00+00', 55000.00, 'https://images.unsplash.com/photo-1507914372368-b2b085b925a1?q=80&w=800', 'retreat', 'health'),
('Медитативный ретрит', 'Глубокое погружение в практики медитации с опытными наставниками.', '2025-07-15 07:00:00+00', 35000.00, 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?q=80&w=800', 'retreat', 'meditation'),
('Ретрит молчания', '7 дней в тишине для глубокого самопознания и перезагрузки.', '2025-08-01 10:00:00+00', 40000.00, 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?q=80&w=800', 'retreat', 'spiritual'),
('Арт-терапия ретрит', 'Творческий ретрит с практиками арт-терапии и самовыражения.', '2025-08-20 11:00:00+00', 38000.00, 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?q=80&w=800', 'retreat', 'art'),
('Эко-ретрит', 'Жизнь в гармонии с природой и обучение экологичному образу жизни.', '2025-09-01 09:00:00+00', 42000.00, 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=800', 'retreat', 'eco'),
('Ретрит осознанности', 'Практики mindfulness и работа с внутренним состоянием.', '2025-09-15 08:00:00+00', 37000.00, 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=800', 'retreat', 'mindfulness'),
('Танцевально-двигательный ретрит', 'Освобождение через движение и танец.', '2025-10-01 10:00:00+00', 36000.00, 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?q=80&w=800', 'retreat', 'dance'),
('Ретрит для пар', 'Укрепление отношений через совместные практики и упражнения.', '2025-10-15 09:00:00+00', 65000.00, 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?q=80&w=800', 'retreat', 'relationship'),
('Ретрит женской силы', 'Раскрытие женственности и работа с энергией.', '2025-11-01 09:00:00+00', 43000.00, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=800', 'retreat', 'women');

-- Insert concerts
INSERT INTO events (title, description, date, price, image_url, category, genre) VALUES
('Симфонический оркестр: Классика в современности', 'Исполнение классических произведений в современной обработке.', '2025-06-10 19:00:00+00', 3500.00, 'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?q=80&w=800', 'concert', 'classical'),
('Рок-фестиваль "Громче!"', 'Выступление легендарных рок-групп и молодых исполнителей.', '2025-07-05 18:00:00+00', 4500.00, 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=800', 'concert', 'rock'),
('Джазовый вечер', 'Импровизации от лучших джазовых музыкантов города.', '2025-07-20 20:00:00+00', 3000.00, 'https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?q=80&w=800', 'concert', 'jazz'),
('Электронная ночь', 'Выступление известных DJ и электронных музыкантов.', '2025-08-15 22:00:00+00', 2500.00, 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=800', 'concert', 'electronic'),
('Вечер русского романса', 'Душевные романсы в исполнении оперных певцов.', '2025-09-01 19:00:00+00', 2800.00, 'https://images.unsplash.com/photo-1507838153414-b4b713384a76?q=80&w=800', 'concert', 'romance'),
('Hip-Hop фестиваль', 'Батлы, фристайл и выступления известных рэперов.', '2025-09-20 20:00:00+00', 3000.00, 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?q=80&w=800', 'concert', 'hip-hop'),
('Фолк-музыка народов мира', 'Аутентичные инструменты и народные мелодии.', '2025-10-05 18:00:00+00', 2200.00, 'https://images.unsplash.com/photo-1511735111819-9a3f7709049c?q=80&w=800', 'concert', 'folk'),
('Поп-хиты 90-х', 'Ностальгический вечер с хитами прошлого.', '2025-10-25 19:00:00+00', 3500.00, 'https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?q=80&w=800', 'concert', 'pop'),
('Блюз и соул вечер', 'Атмосферный концерт в стиле блюз и соул.', '2025-11-10 20:00:00+00', 2800.00, 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?q=80&w=800', 'concert', 'blues'),
('Металл-фест', 'Мощное выступление метал-групп.', '2025-11-30 18:00:00+00', 3000.00, 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=800', 'concert', 'metal');
