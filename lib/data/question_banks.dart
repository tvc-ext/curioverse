import 'dart:math';

import '../models/child_profile.dart';
import '../models/learning_topic.dart';

class _Seed {
  const _Seed(
    this.id,
    this.prompt,
    this.answer,
    this.wrong1,
    this.wrong2,
    this.explanation,
    this.difficulty,
  );

  final String id;
  final String prompt;
  final String answer;
  final String wrong1;
  final String wrong2;
  final String explanation;
  final QuizDifficulty difficulty;
}

const _easy = QuizDifficulty.easy;
const _medium = QuizDifficulty.medium;
const _hard = QuizDifficulty.hard;

const _seeds = <String, List<_Seed>>{
  'moon_phases': [
    _Seed('light', 'Where does moonlight come from?', 'Reflected sunlight', 'The Moon makes light', 'City lights', 'The Moon reflects light from the Sun.', _easy),
    _Seed('orbit', 'What does the Moon travel around?', 'Earth', 'Mars', 'The Sun only', 'The Moon orbits Earth.', _easy),
    _Seed('full', 'What do we call the fully lit-looking phase?', 'Full moon', 'New moon', 'Crescent', 'A full moon shows nearly all of the sunlit half facing us.', _easy),
    _Seed('new', 'Which phase is hardest to see from Earth?', 'New moon', 'Full moon', 'First quarter', 'At new moon, the lit half mostly faces away from Earth.', _easy),
    _Seed('shape', 'Does the Moon physically change shape during its phases?', 'No', 'Yes, every week', 'Only in winter', 'Phases change our view, not the Moon’s round shape.', _medium),
    _Seed('month', 'About how long is one cycle of lunar phases?', '29.5 days', '24 hours', '365 days', 'A synodic lunar month is about 29.5 days.', _medium),
    _Seed('eclipse', 'What must line up for a lunar eclipse?', 'Sun, Earth and Moon', 'Only Earth and Mars', 'Moon and Venus', 'Earth’s shadow falls on the Moon when the three align.', _medium),
    _Seed('tides', 'Which force links the Moon strongly to ocean tides?', 'Gravity', 'Magnetism', 'Sound', 'The Moon’s gravity contributes strongly to Earth’s tides.', _medium),
    _Seed('sameface', 'Why do we usually see the same side of the Moon?', 'It rotates once per orbit', 'It never rotates', 'Clouds hide the other side', 'Synchronous rotation keeps roughly the same face toward Earth.', _hard),
    _Seed('terminator', 'What is the boundary between lunar day and night called?', 'Terminator', 'Equator', 'Crater rim', 'The terminator is the moving line between light and darkness.', _hard),
  ],
  'dinosaur_detective': [
    _Seed('fossil', 'What is a fossil?', 'Preserved evidence of past life', 'A living reptile', 'A type of cloud', 'Fossils preserve bodies, traces or signs of ancient life.', _easy),
    _Seed('footprint', 'What kind of fossil is a dinosaur footprint?', 'Trace fossil', 'Body fossil only', 'Mineral crystal', 'Tracks are trace fossils showing activity.', _easy),
    _Seed('teeth', 'What can dinosaur teeth suggest?', 'What it ate', 'Its exact colour', 'Its name', 'Tooth shapes offer clues about diet.', _easy),
    _Seed('layers', 'Where are older undisturbed rock layers usually found?', 'Below younger layers', 'Always above them', 'Only underwater', 'Superposition places older layers below younger ones.', _medium),
    _Seed('bones', 'Who studies fossils professionally?', 'Palaeontologist', 'Meteorologist', 'Astronaut only', 'Palaeontologists study ancient life through fossils.', _easy),
    _Seed('birds', 'Which living animals are dinosaurs’ surviving descendants?', 'Birds', 'Frogs', 'Whales', 'Modern birds evolved from theropod dinosaurs.', _medium),
    _Seed('extinction', 'When did non-avian dinosaurs become extinct?', 'About 66 million years ago', '600 years ago', 'Before Earth formed', 'The end-Cretaceous extinction occurred about 66 million years ago.', _medium),
    _Seed('asteroid', 'Which impact site is linked to the end-Cretaceous extinction?', 'Chicxulub', 'Everest', 'Mariana Trench', 'The Chicxulub impact contributed to global environmental change.', _hard),
    _Seed('coprolite', 'What is a coprolite?', 'Fossilised dung', 'A dinosaur egg only', 'A volcanic rock', 'Coprolites reveal clues about ancient diets.', _hard),
    _Seed('evidence', 'What should scientists do when new fossil evidence conflicts with an idea?', 'Revise the idea', 'Hide the fossil', 'Ignore the evidence', 'Scientific explanations must respond to reliable evidence.', _medium),
  ],
  'ai_pattern_lab': [
    _Seed('examples', 'What helps an AI model learn patterns?', 'Training examples', 'Magic words', 'Screen brightness', 'Models learn mathematical patterns from data examples.', _easy),
    _Seed('label', 'What is a label in supervised learning?', 'The expected answer', 'A battery', 'A secret password', 'Labels tell the model what an example represents.', _medium),
    _Seed('bias', 'What can unbalanced training data cause?', 'Biased results', 'Perfect fairness', 'More battery power', 'Unrepresentative data can produce unfair or unreliable results.', _medium),
    _Seed('privacy', 'What should you avoid sharing with a public AI tool?', 'Private personal information', 'A public science fact', 'A made-up animal name', 'Personal data should be protected.', _easy),
    _Seed('check', 'Who should verify important AI answers?', 'A responsible person', 'Nobody', 'A random machine only', 'Human judgement remains necessary for important decisions.', _easy),
    _Seed('hallucination', 'What is an AI hallucination?', 'A confident but incorrect output', 'A screen animation', 'A faster processor', 'Generative models can produce plausible-sounding false information.', _medium),
    _Seed('testdata', 'Why keep test data separate from training data?', 'To measure generalisation fairly', 'To make files colourful', 'To hide every answer', 'Unseen test data checks performance beyond memorised examples.', _hard),
    _Seed('overfit', 'What is overfitting?', 'Learning training details but failing on new examples', 'Learning nothing', 'Turning off a model', 'An overfit model does not generalise well.', _hard),
    _Seed('confidence', 'Does a high AI confidence score guarantee correctness?', 'No', 'Always', 'Only on Tuesdays', 'Confidence is a model estimate and can be miscalibrated.', _hard),
    _Seed('purpose', 'What should come before choosing an AI system?', 'A clear problem and responsible use', 'Buying the largest computer', 'Collecting every private detail', 'Purpose, risk and human needs should guide AI use.', _medium),
  ],
  'ocean_networks': [
    _Seed('phytoplankton', 'What begins many ocean food webs?', 'Phytoplankton', 'Plastic', 'Sand alone', 'Phytoplankton capture solar energy.', _easy),
    _Seed('gills', 'What organ lets most fish take oxygen from water?', 'Gills', 'Wings', 'Fur', 'Gills exchange gases with water.', _easy),
    _Seed('coral', 'Are reef-building corals animals?', 'Yes', 'No, all are rocks', 'Only at night', 'Coral polyps are animals living in colonies.', _medium),
    _Seed('mammal', 'Which ocean animal is a mammal?', 'Dolphin', 'Shark', 'Octopus', 'Dolphins breathe air and nurse their young.', _easy),
    _Seed('salinity', 'What does ocean salinity measure?', 'Dissolved salts', 'Wave height', 'Fish speed', 'Salinity describes the concentration of dissolved salts.', _medium),
    _Seed('current', 'What can move heat around the planet?', 'Ocean currents', 'Seashells alone', 'Sand castles', 'Currents redistribute heat and influence climate.', _medium),
    _Seed('acidification', 'What gas drives modern ocean acidification when absorbed?', 'Carbon dioxide', 'Helium', 'Neon', 'Dissolved carbon dioxide changes seawater chemistry.', _hard),
    _Seed('depth', 'Which ocean zone receives enough light for photosynthesis?', 'Sunlit zone', 'Abyss only', 'Trench floor only', 'Photosynthesis is concentrated in the photic or sunlit zone.', _medium),
    _Seed('biodiversity', 'What often helps an ecosystem recover from disturbance?', 'Biodiversity', 'Removing all predators', 'More pollution', 'Varied species and relationships improve resilience.', _hard),
    _Seed('whale', 'Why must whales surface?', 'They breathe air with lungs', 'They need sunlight to swim', 'Their gills dry out', 'Whales are mammals with lungs.', _easy),
  ],
  'isro_mission_lab': [
    _Seed('agency', 'What does ISRO stand for?', 'Indian Space Research Organisation', 'International Sea Research Office', 'Indian Science Railway Office', 'ISRO is India’s national space agency.', _easy),
    _Seed('vikram', 'What was Vikram in Chandrayaan-3?', 'Lunar lander', 'Mars telescope', 'Launch pad', 'Vikram carried the Pragyan rover to the lunar surface.', _easy),
    _Seed('pragyan', 'What was Pragyan in Chandrayaan-3?', 'Lunar rover', 'Weather balloon', 'Space station', 'Pragyan explored near the landing site.', _easy),
    _Seed('aditya', 'What does Aditya-L1 study?', 'The Sun', 'Deep oceans', 'Dinosaurs', 'Aditya-L1 is India’s solar observatory mission.', _easy),
    _Seed('mom', 'Which planet did India’s Mars Orbiter Mission study?', 'Mars', 'Venus', 'Jupiter', 'The mission entered Mars orbit in 2014.', _easy),
    _Seed('pslv', 'What type of machine is PSLV?', 'Launch vehicle', 'Lunar crater', 'Ocean robot', 'PSLV launches spacecraft into orbit.', _medium),
    _Seed('navic', 'What is NavIC?', 'Indian regional navigation system', 'A Moon rock', 'A telescope mirror', 'NavIC provides positioning, navigation and timing services.', _medium),
    _Seed('aryabhata', 'What was Aryabhata?', 'India’s first satellite', 'First lunar rover', 'A launch centre', 'Aryabhata was launched in 1975.', _medium),
    _Seed('southpolar', 'What made Chandrayaan-3’s landing region notable?', 'It was near the lunar south polar region', 'It was on Mars', 'It was inside the Sun', 'India achieved a soft landing at high southern lunar latitude.', _hard),
    _Seed('l1', 'What is the Sun–Earth L1 region useful for?', 'Nearly continuous solar observation', 'Landing submarines', 'Growing forests', 'A spacecraft near L1 can monitor the Sun with few Earth eclipses.', _hard),
  ],
  'india_time_travel': [
    _Seed('indus', 'Which civilisation built cities such as Harappa and Mohenjo-daro?', 'Indus Valley Civilisation', 'Roman Empire', 'Maya civilisation', 'These were major urban centres of the Indus civilisation.', _easy),
    _Seed('ashoka', 'Which emperor issued messages on rocks and pillars?', 'Ashoka', 'Akbar only', 'Shivaji Maharaj', 'Ashokan edicts communicated policies and ethical ideas.', _easy),
    _Seed('constitution', 'When did India’s Constitution come into effect?', '26 January 1950', '15 August 1947', '2 October 1869', 'India celebrates Republic Day on 26 January.', _easy),
    _Seed('independence', 'When did India become independent?', '15 August 1947', '26 January 1950', '1 January 1900', 'India gained independence from British rule in 1947.', _easy),
    _Seed('drafting', 'Who chaired the Constitution’s Drafting Committee?', 'B. R. Ambedkar', 'C. V. Raman', 'Homi Bhabha', 'Dr Ambedkar chaired the Drafting Committee.', _medium),
    _Seed('dandi', 'Which movement included the Dandi Salt March?', 'Civil Disobedience Movement', 'Green Revolution', 'Space programme', 'Gandhi’s 1930 march challenged the salt laws.', _medium),
    _Seed('maurya', 'Which dynasty did Ashoka belong to?', 'Maurya', 'Chola', 'Gupta', 'Ashoka was a Mauryan emperor.', _medium),
    _Seed('ajanta', 'What are the Ajanta Caves especially known for?', 'Buddhist art and architecture', 'Modern skyscrapers', 'Space rockets', 'Ajanta preserves rock-cut monuments, paintings and sculpture.', _medium),
    _Seed('sources', 'Which is a primary source for studying an ancient ruler?', 'An inscription from the ruler’s time', 'A new fictional film', 'An unsourced rumour', 'Contemporary inscriptions provide direct historical evidence.', _hard),
    _Seed('periods', 'Why can historical period labels be imperfect?', 'Real change is gradual and regions differ', 'Dates never matter', 'Evidence is unnecessary', 'Periods are useful models, but history does not change everywhere at once.', _hard),
  ],
  'seven_wonders': [
    _Seed('india', 'Which New Seven Wonder is in India?', 'Taj Mahal', 'Machu Picchu', 'Colosseum', 'The Taj Mahal is in Agra.', _easy),
    _Seed('china', 'Which wonder stretches across northern China?', 'Great Wall of China', 'Petra', 'Chichén Itzá', 'The Great Wall consists of many fortification sections.', _easy),
    _Seed('jordan', 'Which rock-cut wonder is in Jordan?', 'Petra', 'Colosseum', 'Christ the Redeemer', 'Petra was an important Nabataean city.', _medium),
    _Seed('italy', 'Which ancient amphitheatre is in Rome?', 'Colosseum', 'Taj Mahal', 'Machu Picchu', 'The Colosseum hosted spectacles in ancient Rome.', _easy),
    _Seed('peru', 'Which Inca site stands high in the Andes?', 'Machu Picchu', 'Petra', 'Great Wall', 'Machu Picchu is in present-day Peru.', _medium),
    _Seed('mexico', 'Which Maya site includes the pyramid El Castillo?', 'Chichén Itzá', 'Colosseum', 'Taj Mahal', 'Chichén Itzá is on Mexico’s Yucatán Peninsula.', _medium),
    _Seed('brazil', 'Which wonder overlooks Rio de Janeiro?', 'Christ the Redeemer', 'Petra', 'Great Wall', 'The statue stands on Corcovado mountain.', _easy),
    _Seed('list', 'How were the New Seven Wonders announced?', 'Through a global public campaign', 'By an ancient Roman law', 'By a space mission', 'The modern list was announced in 2007 after a public campaign.', _hard),
    _Seed('ancient', 'Which surviving structure belonged to the Ancient Seven Wonders?', 'Great Pyramid of Giza', 'Taj Mahal', 'Christ the Redeemer', 'The Great Pyramid is the only substantially surviving ancient wonder.', _hard),
    _Seed('protect', 'Why is conservation important at famous monuments?', 'It protects evidence and heritage', 'It erases history', 'It prevents all learning', 'Careful conservation preserves sites for future generations.', _medium),
  ],
  'human_evolution': [
    _Seed('primate', 'Humans belong to which mammal group?', 'Primates', 'Marsupials', 'Cetaceans', 'Humans are primates.', _easy),
    _Seed('ancestor', 'Did humans evolve from chimpanzees living today?', 'No, we share ancient ancestors', 'Yes, directly', 'Humans came from dolphins', 'Humans and chimpanzees are separate branches with shared ancestors.', _medium),
    _Seed('africa', 'Where did Homo sapiens emerge?', 'Africa', 'Antarctica', 'The Moon', 'Fossil and genetic evidence points to Africa.', _easy),
    _Seed('age', 'About how old is Homo sapiens?', 'Roughly 300,000 years', '3,000 years', '30 million years', 'Early Homo sapiens fossils date to roughly 300,000 years ago.', _medium),
    _Seed('evidence', 'Which evidence helps study human evolution?', 'Fossils, archaeology and DNA', 'Only legends', 'Weather reports alone', 'Independent evidence types reveal different parts of the story.', _easy),
    _Seed('tree', 'What shape best represents evolution?', 'Branching tree', 'Straight ladder', 'Perfect circle', 'Populations split and form branching relationships.', _medium),
    _Seed('bipedal', 'What does bipedal mean?', 'Walking mainly on two legs', 'Living underwater', 'Having wings', 'Habitual bipedalism is an important hominin trait.', _easy),
    _Seed('neanderthal', 'Did Homo sapiens and Neanderthals ever interbreed?', 'Yes', 'Never', 'Only in fiction', 'Genomes show interbreeding between populations.', _hard),
    _Seed('variation', 'What does natural selection act on?', 'Inherited variation', 'Wishful thinking', 'Traits gained by exercise alone', 'Heritable differences can affect survival and reproduction.', _hard),
    _Seed('culture', 'Besides biology, what strongly shaped humans?', 'Culture and cooperation', 'No social behaviour', 'Only climate', 'Learning, language, tools and cooperation shaped human lives.', _medium),
  ],
  'animal_detective': [
    _Seed('feathers', 'Which covering identifies all living birds?', 'Feathers', 'Fur', 'Wet skin', 'Feathers are unique to birds among living animals.', _easy),
    _Seed('tiger', 'Which animal has dark stripes on orange or pale fur?', 'Tiger', 'Dolphin', 'Peafowl', 'Individual tigers have distinctive stripe patterns.', _easy),
    _Seed('mammal', 'What do female mammals produce for their young?', 'Milk', 'Feathers', 'Gills', 'Milk production is a defining mammalian trait.', _easy),
    _Seed('amphibian', 'Which animal group often has moist skin and aquatic larvae?', 'Amphibians', 'Birds', 'Mammals', 'Many amphibians change from aquatic larvae to adults.', _medium),
    _Seed('reptile', 'Which feature is typical of reptiles?', 'Scaly skin', 'Feathers on every species', 'Milk glands', 'Reptiles have keratinised scales or scutes.', _medium),
    _Seed('insect', 'How many legs does an adult insect have?', 'Six', 'Eight', 'Ten', 'Adult insects have three pairs of legs.', _easy),
    _Seed('arachnid', 'How many legs does a typical adult spider have?', 'Eight', 'Six', 'Four', 'Spiders are arachnids with four pairs of legs.', _easy),
    _Seed('camouflage', 'What is camouflage used for?', 'Blending with surroundings', 'Making every animal louder', 'Changing the weather', 'Camouflage can help animals hide from predators or prey.', _medium),
    _Seed('taxonomy', 'What is taxonomy?', 'Science of naming and classifying organisms', 'Study of clouds', 'Rocket engineering', 'Taxonomy organises biodiversity using shared characteristics.', _hard),
    _Seed('uncertain', 'What should you report when a photo lacks enough identification clues?', 'Uncertainty', 'A made-up certainty', 'No evidence', 'Responsible identification states uncertainty and seeks more evidence.', _hard),
  ],
};

List<QuizQuestion> questionBankFor(String topicId) {
  final seeds = _seeds[topicId] ?? const <_Seed>[];
  return [
    for (final seed in seeds)
      for (var variant = 0; variant < 5; variant++)
        _buildQuestion(seed, variant),
  ];
}

List<QuizQuestion> createQuizSession(
  String topicId, {
  AgeBand ageBand = AgeBand.maker9to11,
  int size = 10,
  Random? random,
}) {
  final source = random ?? Random();
  final seeds = [...?_seeds[topicId]]..shuffle(source);
  final variants = switch (ageBand) {
    // A gentle stretch: mostly direct recall, plus medium reasoning.
    AgeBand.explorer6to8 => [0, 0, 0, 1, 1, 1, 3, 3, 2, 0],
    // More application and inference than simple recall.
    AgeBand.maker9to11 => [0, 1, 1, 2, 2, 3, 3, 4, 1, 2],
    // A deliberately demanding mix dominated by hard reasoning.
    AgeBand.creator12to14 => [1, 2, 2, 2, 3, 4, 4, 4, 2, 4],
  }..shuffle(source);
  return [
    for (var index = 0; index < seeds.take(size).length; index++)
      _buildQuestion(
        seeds[index],
        variants[index % variants.length],
      ),
  ];
}

QuizQuestion _buildQuestion(_Seed seed, int variant) {
  final prompt = switch (variant) {
    0 => seed.prompt,
    1 => 'Think carefully: ${seed.prompt}',
    2 => 'Level challenge — ${seed.prompt}',
    3 => 'Choose the best answer: ${seed.prompt}',
    _ => 'Final clue — ${seed.prompt}',
  };
  final options = switch (variant) {
    0 => [seed.answer, seed.wrong1, seed.wrong2],
    1 => [seed.wrong1, seed.answer, seed.wrong2],
    2 => [seed.wrong1, seed.wrong2, seed.answer],
    3 => [seed.answer, seed.wrong2, seed.wrong1],
    _ => [seed.wrong2, seed.answer, seed.wrong1],
  };
  final correctIndex = switch (variant) { 0 || 3 => 0, 1 || 4 => 1, _ => 2 };
  return QuizQuestion(
    id: '${seed.id}-v$variant',
    prompt: prompt,
    options: options,
    correctIndex: correctIndex,
    explanation: seed.explanation,
    difficulty: _difficultyFor(seed.difficulty, variant),
  );
}


QuizDifficulty _difficultyFor(QuizDifficulty seedDifficulty, int variant) {
  final variantDifficulty = switch (variant) {
    0 => QuizDifficulty.easy,
    1 || 3 => QuizDifficulty.medium,
    _ => QuizDifficulty.hard,
  };
  return seedDifficulty.index > variantDifficulty.index
      ? seedDifficulty
      : variantDifficulty;
}
