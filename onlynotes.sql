-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 05, 2026 at 04:14 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `onlynotes`
--

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `message_text` text NOT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `note`
--

CREATE TABLE `note` (
  `note_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `uploader_id` int(11) NOT NULL,
  `upvotes` int(11) DEFAULT 0,
  `visibility` enum('public','hidden') DEFAULT 'public'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `note`
--

INSERT INTO `note` (`note_id`, `title`, `subtitle`, `content`, `created_at`, `uploader_id`, `upvotes`, `visibility`) VALUES
(1, 'Introduction to Python', 'A beginner-friendly guide to Python syntax and basic data types.', 'Learn about variables, loops, and conditional statements in Python. This note covers list comprehensions and basic dictionary operations.', '2026-01-05 13:43:28', 10, 0, 'public'),
(2, 'Linear Algebra', 'Essential concepts of vector spaces and matrix transformations.', 'Understand how to solve systems of linear equations using Gaussian elimination. This Covers eigenvalues and eigenvectors for data science applications.', '2026-01-05 13:46:48', 10, 0, 'public'),
(3, 'Thermodynamics', 'Laws governing heat, energy, and work in physical systems.', 'Detailed study of the First and Second Laws of Thermodynamics. Explains entropy and the efficiency of heat engines in engineering.', '2026-01-05 13:48:40', 10, 0, 'public'),
(4, 'Organic Chemistry I', 'A study of carbon-based compounds and their chemical reactions.', 'Includes detailed mechanisms for SN1, SN2, E1, and E2 reactions. This Focuses on stereochemistry and the nomenclature of alkanes and alkenes.', '2026-01-05 13:51:15', 2, 0, 'public'),
(5, 'Quantum Physics', 'Introduction to wave-particle duality and the Schrodinger equation.', 'Introduction to wave-particle duality and the Schrodinger equation. Explores the probabilistic nature of subatomic particles and quantum states. Detailed explanation of the Heisenberg Uncertainty Principle and tunneling.', '2026-01-05 13:52:54', 2, 0, 'public'),
(6, 'Bisection Method', 'Numerical Analysis: A side-by-side guide to the steady Bisection method and the fast Fixed-Point iteration for solving non-linear equations.', '4.1 Bisection method\r\nGiven, \r\nf(x) = x^3 - 7x^2 + 15x - 6\r\ninterval [a,b] = [1, 3.2]\r\nmachine epsilon (accuracy), E = 0.05\r\nwe have to find the roots in the given interval in the given accuracy\r\n\r\nsteps:\r\nfind m (midpoint), m=a+b/2\r\nfind f(a) and f(m)\r\nif f(a) -> (+) , f(m) -> (-) or vice versa (opposite sign), root inside [a,m] -> change endpoint, b=m\r\nif f(a) -> (+) , f(m) -> (+) or vice versa (same sign),     root inside [b,m] -> change startpoint -> a=m\r\nif f(m) = 0 -> m is root\r\nstop when root found or when f(m) > E\r\n\r\nadvantage\r\n-guaranteed to find root\r\n\r\ndisadvantage\r\n-takes time\r\n-cannot find multiple roots\r\n\r\nadditional info:\r\nnumber of iteration (k), k >= { ( log|b - a| - log E ) / log 2 } - 1\r\n\r\ntitle : CSE330 Final Cheat-Sheet - 4.2 Fixed Point Iteration\r\nsub title : contains all the necessary formulas from chapter 4 and onwards\r\ncontent :\r\n\r\n4.2 Fixed Point Iteration\r\nGiven,\r\nf(x) = x^2 - 2x - 3 = 0 (degree 2, so 2 roots)\r\nwe have to find all the roots of the equation\r\n\r\nSteps:\r\nassume f(x) = 0\r\nfind out g(x) = x by by isolating x from the equation, show such 2 equations -> g1(x) and g2(x)\r\nrepeat 4 5 6\r\nx0 = 0      g(x0) = x1\r\nx1 = g(x0)  g(x1) = x2 and so on\r\nstop when x equal g(x), x is the root\r\ndo this for g1 and g2\r\n\r\n*Contraction mapping theorem\r\nfind out how fast u can find out a root or if root finding is not possible\r\nconvergence means x and g(x) closes in gradually and then become equal meaning x is the root\r\nlamba = |g\'(x)|\r\n\r\nSteps:\r\nif lamda = 0 -> super linear convergent (takes less time or iteration to find root)\r\nif 0<lambda<1 -> linear convergent (takes more time)\r\nif lambda>=1 -> divergent (root cannot be found)\r\n\r\n', '2026-01-05 13:54:54', 2, 0, 'public'),
(7, 'Macroeconomic Trends', 'Analyzing global economic indicators like GDP and inflation rates.', 'Macroeconomic Trends it is the analysis of global economic indicators like GDP and inflation rates. Discusses the impact of monetary policy on national economic growth.It includes analysis of fiscal stimulus packages and their long-term effects.', '2026-01-05 14:13:10', 3, 0, 'public'),
(8, 'Cellular Respiration', 'The biochemical process of converting glucose into ATP energy.', 'Cellular Respiration is the biochemical process of converting glucose into ATP energy. Breaks down the stages of Glycolysis, the Krebs Cycle, and Electron Transport. It Explains the role of mitochondria in aerobic and anaerobic respiration.', '2026-01-05 14:14:46', 3, 0, 'public'),
(9, 'World Geography', 'Exploring the physical features and climate zones of Earth.', 'World Geography is the study of exploring the physical features and climate zones of Earth. Discusses plate tectonics, mountain formation, and ocean currents. It examines the relationship between geography and human civilization.', '2026-01-05 14:17:12', 3, 0, 'public'),
(10, 'Data Structures', 'Overview of arrays, linked lists, stacks, and binary trees.', 'Data Structures is the study of arrays, linked lists, stacks, and binary trees. Discusses time complexity and Big O notation for common algorithms. Implementation details for hash tables and priority queues are included.', '2026-01-05 14:36:55', 4, 0, 'public'),
(11, 'Medieval History', 'A timeline of the major events during the European Middle Ages.', 'Examines the feudal system and the influence of the Catholic Church. Covers the Black Death and the transition into the Renaissance era.', '2026-01-05 14:38:26', 4, 0, 'public'),
(12, 'World War 2', 'A global conflict from 1939 to 1945 in which the Allies defeated the Axis powers after widespread devastation and loss of life.', 'World War II[b] or the Second World War (1 September 1939 – 2 September 1945) was a global conflict between two coalitions: the Allies and the Axis powers. Nearly all of the world\'s countries participated, with many nations mobilising their resources in pursuit of total war. Tanks and aircraft played major roles, enabling the strategic bombing of cities and delivery of the first and only nuclear weapons ever used in war. World War II is the deadliest conflict in history, causing the death of 70 to 85 million people, more than half of whom were civilians. Millions died in genocides, including the Holocaust, and by massacres, starvation, and disease. After the Allied victory, Germany, Austria, Japan, and Korea were occupied, and German and Japanese leaders were put on trial for war crimes.\r\n\r\nThe causes of World War II included unresolved tensions in the aftermath of World War I, the rise of fascism in Europe and militarism in Japan. Key events preceding the war included Japan\'s invasion of Manchuria in 1931, the Spanish Civil War, the outbreak of the Second Sino-Japanese War in 1937, and Germany\'s annexations of Austria and the Sudetenland. World War II is generally considered to have begun on 1 September 1939, when Nazi Germany, under Adolf Hitler, invaded Poland, after which the United Kingdom and France declared war on Germany. Poland was also invaded by the Soviet Union in mid-September, and was partitioned between Germany and the Soviet Union under the Molotov–Ribbentrop Pact. In 1940, the Soviet Union annexed the Baltic states and parts of Finland and Romania, while Germany conquered Norway, Belgium, Luxembourg and the Netherlands. After the fall of France in June 1940, the war continued mainly between Germany, now assisted by Fascist Italy, and the British Empire, with fighting in the Balkans, Mediterranean, and Middle East, East Africa, the aerial Battle of Britain and the Blitz, and the naval Battle of the Atlantic. By mid-1941 Yugoslavia and Greece had also been defeated by Axis countries. In June 1941, Germany invaded the Soviet Union, opening the Eastern Front and initially making large territorial gains along with Axis allies.\r\n\r\nIn December 1941, Japan attacked American and British territories in Asia and the Pacific, including Pearl Harbor in Hawaii, leading the United States to enter the war against the Axis. Japan conquered much of coastal China and Southeast Asia, but its advances in the Pacific were halted in June 1942 at the Battle of Midway. In early 1943, Axis forces were defeated in North Africa and at Stalingrad in the Soviet Union. An Allied invasion of Italy in July resulted in the fall of its fascist regime, and Allied offensives in the Pacific and the Soviet Union forced the Axis to retreat on all fronts. In 1944, the Western Allies invaded France at Normandy, the Soviet Union advanced into central Europe, and the US crippled Japan\'s navy and captured key Pacific islands.\r\n\r\nThe war in Europe concluded with the liberation of German-occupied territories and the invasion of Germany by the Allies which culminated in the fall of Berlin to Soviet troops, and Germany\'s unconditional surrender on 8 May 1945. ', '2026-01-05 14:40:58', 4, 0, 'public'),
(13, 'World War 1', 'World War I was a global war from 1914 to 1918, mainly fought between the Allies and the Central Powers, and it reshaped Europe politically and socially.', 'World War I,[b] or the First World War (28 July 1914 – 11 November 1918), also known as the Great War, was a global conflict between two coalitions: the Allies (or Entente) and the Central Powers. Major areas of conflict included Europe and the Middle East, as well as parts of Africa and the Asia-Pacific. The war saw important developments in weaponry including tanks, aircraft, artillery, machine guns, and chemical weapons. One of the deadliest conflicts in history, it resulted in an estimated 30 million military casualties, and 8 million civilian deaths from war-related causes and genocide. The movement of large numbers of people was a major factor in the deadly Spanish flu pandemic.\r\n\r\nThe causes of World War I included the rise of the German Empire and decline of the Ottoman Empire, which disturbed the long-standing balance of power in Europe, the exacerbation of imperial rivalries, and an arms race between the great powers. Growing tensions in the Balkans reached a breaking point on 28 June 1914 when Gavrilo Princip, a Bosnian Serb, assassinated Franz Ferdinand, the heir to the Austro-Hungarian throne. Austria-Hungary blamed Serbia, and declared war on 28 July. After Russia mobilised in Serbia\'s defence, Germany declared war on Russia and France, who had an alliance. The United Kingdom entered the war after Germany invaded Belgium, and the Ottoman Empire joined the Central Powers in November. Germany\'s strategy in 1914 was to quickly defeat France before transferring its forces to the east, but its advance was halted in September, and by the end of the year the Western Front consisted of a near-continuous line of trenches from the English Channel to Switzerland. The Eastern Front was more dynamic, but neither side gained a decisive advantage, despite costly offensives. Italy, Bulgaria, Romania, Greece and others entered the war from 1915 onward.\r\n\r\nMajor battles, including those at Verdun, the Somme, and Passchendaele, failed to break the stalemate on the Western Front. In April 1917, the United States joined the Allies after Germany resumed unrestricted submarine warfare against Atlantic shipping. Later that year, the Bolsheviks seized power in Russia in the October Revolution; Soviet Russia signed an armistice with the Central Powers in December, followed by a separate peace in March 1918. That month, Germany launched a spring offensive in the west, which despite initial successes left the German Army exhausted and demoralised. The Allied Hundred Days Offensive, beginning in August 1918, caused a collapse of the German front line. Following the Vardar Offensive, Bulgaria signed an armistice in late September. By early November, the Allies had signed armistices with the Ottomans and with Austria-Hungary, leaving Germany isolated. Facing a revolution at home, Kaiser Wilhelm II abdicated on 9 November, and the war ended with the Armistice of 11 November 1918.\r\n\r\nThe Paris Peace Conference of 1919–1920 imposed settlements on the defeated powers. Under the Treaty of Versailles, Germany lost significant territories, was disarmed, and was required to pay large war reparations to the Allies. The dissolution of the Russian, German, Austro-Hungarian, and Ottoman empires led to new national boundaries and the creation of new independent states including Poland, Finland, the Baltic states, Czechoslovakia, and Yugoslavia. The League of Nations was established to maintain world peace, but its failure to manage instability during the interwar period contributed to the outbreak of World War II in 1939.', '2026-01-05 14:42:37', 4, 0, 'public'),
(14, 'Cold War', 'The Cold War was a period of political and military tension after World War II between the United States and its allies and the Soviet Union', 'The Cold War was a period of international geopolitical rivalry between the United States (US) and the Soviet Union (USSR) and their respective allies, the capitalist Western Bloc and communist Eastern Bloc, which began in the aftermath of the Second World War[A] and ended with the dissolution of the Soviet Union in 1991. The term cold war is used because there was no direct fighting between the two superpowers, though each supported opposing sides in regional conflicts known as proxy wars. In addition to the struggle for ideological and economic influence and an arms race in both conventional and nuclear weapons, the Cold War was expressed through technological rivalries such as the Space Race, espionage, propaganda campaigns, embargoes, and sports diplomacy.\r\n\r\nAfter the end of the Second World War in 1945, during which the US and USSR had been allies, the USSR installed satellite governments in its occupied territories in Eastern Europe and North Korea by 1949, resulting in the political division of Europe (and Germany) by an \"Iron Curtain\". The USSR tested its first nuclear weapon in 1949, four years after their use by the US on Hiroshima and Nagasaki, and allied with the People\'s Republic of China, founded in 1949. The US declared the Truman Doctrine of \"containment\" of communism in 1947, launched the Marshall Plan in 1948 to assist Western Europe\'s economic recovery, and founded the NATO military alliance in 1949 (matched by the Soviet-led Warsaw Pact in 1955). The Berlin Blockade of 1948 to 1949 was an early confrontation, as was the Korean War of 1950 to 1953, which ended in a stalemate.\r\n\r\nUS involvement in regime change during the Cold War included support for First World anti-communist and right-wing dictatorships and uprisings, while Soviet involvement included the funding of Second World left-wing parties, wars of independence, and dictatorships. As nearly all the colonial states underwent decolonization, many became Third World battlefields of the Cold War. Both powers used economic aid in an attempt to win the loyalty of non-aligned countries. The Cuban Revolution of 1959 installed the first communist regime in the Western Hemisphere, and in 1962, the Cuban Missile Crisis began after deployments of US missiles in Europe and Soviet missiles in Cuba; it is widely considered the closest the Cold War came to escalating into nuclear war. Another major proxy conflict was the Vietnam War of 1955 to 1975, which ended in defeat for the US.\r\n\r\nThe USSR solidified its domination of Eastern Europe with its crushing of the Hungarian Revolution in 1956 and the Warsaw Pact invasion of Czechoslovakia in 1968. Relations between the USSR and China broke down by 1961, with the Sino-Soviet split bringing the two states to the brink of war amid a border conflict in 1969. In 1972, the US initiated diplomatic contacts with China and the US and USSR signed a series of treaties limiting their nuclear arsenals during a period known as détente. In 1979, the toppling of US-allied governments in Iran and Nicaragua and the outbreak of the Soviet–Afghan War again raised tensions. In 1985, Mikhail Gorbachev became leader of the USSR and expanded political freedoms, which contributed to the revolutions of 1989 in the Eastern Bloc and the collapse of the USSR in 1991, ending the Cold War.', '2026-01-05 14:47:20', 4, 0, 'public'),
(15, 'American Revolution', 'The American Revolution was a war from 1775 to 1783 in which the thirteen American colonies gained independence from British rule.', 'The American Revolution (1765–1783) was a political conflict involving the Thirteen Colonies and Great Britain, that began as a rebellion demanding reform and evolved into a revolution resulting in a complete separation that entirely replaced the social and political order, as an outcome of the American Revolutionary War and the consequential sovereign independence of the former colonies as the United States. The Second Continental Congress established the Continental Army and appointed George Washington as its commander-in-chief in 1775. The following year, the Congress unanimously adopted the Declaration of Independence. Throughout most of the war, the outcome appeared uncertain. However, in 1781, a decisive victory by Washington and the Continental Army in the Siege of Yorktown led King George III and the British to negotiate the cessation of colonial rule and the acknowledgment of American sovereignty, formalized in the Treaty of Paris in 1783.\r\n\r\nDiscontent with colonial rule began shortly after the French and Indian War in 1763. Even though the colonies had fought in and supported the war directly with funds and materiel, the British Parliament imposed new taxes to ostensibly compensate for wartime costs and transferred control of the colonies\' western lands to British officials in Montreal. Representatives from several colonies convened in New York City for the Stamp Act Congress in 1765; its \"Declaration of Rights and Grievances\" argued that this taxation without representation and other policies violated their rights as Englishmen. In 1767, though the Stamp Act was repealed, tensions flared again following British Parliament\'s passage of the Townshend Acts. In an effort to quell the mounting rebellion, King George III deployed British troops to Boston, where they killed antagonists in the 1770 Boston Massacre . In December 1773, the underground Sons of Liberty orchestrated the Boston Tea Party, during which they dumped chests of taxed tea owned by the British East India Company into Boston Harbor. Parliament responded by enacting a series of punitive laws, which effectively ended self-government in Massachusetts but also intensified support for the revolutionary cause among Americans.\r\n\r\nIn 1774, twelve of the Thirteen Colonies sent delegates to the First Continental Congress; the Province of Georgia joined in 1775. The First Continental Congress began coordinating Patriot resistance through underground networks of committees largely built on the foundations of the Sons of Liberty. In August 1775, King George III proclaimed Massachusetts to be in a state of rebellion. The British attempted to disarm the colonists, resulting in the Battles of Lexington and Concord, sparking the Revolutionary War. The Continental Army then surrounded Boston, forcing the British to withdraw by sea in March 1776, and leaving Patriots in control in every colony. In May 1776, Congress voted to suppress all forms of Crown authority, to be replaced by locally created authority, and each colony created a state constitution. On July 2, the Congress passed the Lee Resolution, affirming their support for joint independence, and on July 4, 1776 they unanimously adopted the Declaration of Independence, having evolved into a revolution now basing their claims on universal rights and famously proclaiming that \"all men are created equal\". The Second Continental Congress soon after began deliberating the Articles of Confederation, an effort to establish a multi-state self-governing coordinating body capable of negotiating international treaties and prosecuting the war.\r\n\r\nThe Revolutionary War continued for another five years during which France ultimately entered, supporting the revolutionary cause. On September 28, 1781, Washington led the Continental Army\'s most decisive victory at the Siege of Yorktown, leading to the collapse of King George\'s control of Parliament. Consensus in Parliament soon shifted to the war ending on American terms. On September 3, 1783, the British signed the Treaty of Paris, ceding to the new nation nearly all the territory east of the Mississippi River and south of the Great Lakes. The United States became the first nation to establish a federal republic with a written constitution based on the principles of universal natural rights, consent of the governed and equality under the law, albeit with significant democratic limitations compared to later evolution of the concept.', '2026-01-05 14:49:22', 4, 0, 'public'),
(16, 'Russian Civil War', 'The Russian Civil War was a conflict from 1917 to 1923 between the Red Army (Bolsheviks) and the White forces, leading to the creation of the Soviet Union.', 'From 1917 to 1922, the Russian Civil War was a multi-party civil war in the former Russian Empire sparked by the overthrowing of the Russian Provisional Government in the October Revolution, as many factions vied to determine Russia\'s political future. It resulted in the formation of the Russian Socialist Federative Soviet Republic and later the Soviet Union in most of its territory. Its finale marked the end of the Russian Revolution, which was one of the key events of the 20th century.\r\n\r\nThe Russian monarchy ended with the abdication of Tsar Nicholas II during the February Revolution, and Russia was in a state of political flux. A tense summer culminated in the October Revolution, where the Bolsheviks overthrew the provisional government of the new Russian Republic. Bolshevik seizure of power was not universally accepted, and the country descended into a conflict which became a full-scale civil war in May–June 1918. The two largest combatants were the Red Army, fighting for the establishment of a Bolshevik-led socialist state headed by Vladimir Lenin, and the forces known as the White movement (and its White Army), led mainly by the right-leaning officers of the Russian Empire, united around the figure of Alexander Kolchak. In addition, rival militant socialists, notably the Ukrainian anarchists of the Makhnovshchina and Left Socialist-Revolutionaries, were involved in conflict against the Bolsheviks. They, as well as non-ideological green armies, opposed the Bolsheviks, the Whites and the foreign interventionists. Thirteen foreign states intervened against the Red Army, notably the Allied intervention, whose primary goal was re-establishing the Eastern Front of World War I. Three foreign states of the Central Powers also intervened, rivaling the Allied intervention with the main goal of retaining the territory they had received in the Treaty of Brest-Litovsk with Soviet Russia.\r\n\r\nThe Bolsheviks initially consolidated control over most of the former empire. The Treaty of Brest-Litovsk was an emergency peace with the German Empire, who had captured vast swathes of the Russian territory during the chaos of the revolution. In May 1918, the Czechoslovak Legion in Russia revolted in Siberia. In reaction, the Allies began their North Russian and Siberian interventions. That, combined with the creation of the Provisional All-Russian Government, saw the reduction of Bolshevik-controlled territory to most of European Russia and parts of Central Asia. In 1919, the White Army launched several offensives from the east in March, the south in July, and west in October. The advances were later checked by the Eastern Front counteroffensive, the Southern Front counteroffensive, and the defeat of the Northwestern Army.\r\n\r\nBy 1919, the White armies were in retreat and by the start of 1920 were defeated on all three fronts. Although the Bolsheviks were victorious, the territorial extent of the Russian state had been reduced, for many non-Russian ethnic groups had used the disarray to push for national independence. In March 1921, during a related war against Poland, the Peace of Riga was signed, splitting disputed territories in Belarus and Ukraine between the Republic of Poland on one side and Soviet Russia and Soviet Ukraine on the other. Soviet Russia invaded all the newly independent nations of the former empire or supported the Bolshevik and socialist forces there, although the success of such invasions was limited. Estonia, Latvia, and Lithuania all repelled Soviet invasions, Ukraine and Belarus were divided (as a result of the Polish–Soviet War), while Armenia, Azerbaijan and Georgia were occupied by the Red Army. By 1921, the Bolsheviks had defeated the national movements in Ukraine and the Caucasus, although anti-Bolshevik uprisings in Central Asia lasted until the late 1920s.\r\n\r\nThe armies under Kolchak were eventually forced on a mass retreat eastward. Bolshevik forces advanced east, despite encountering resistance in Chita, Yakut and Mongolia. Soon the Red Army split the Don and Volunteer armies, forcing evacuations in Novorossiysk in March and Crimea in November 1920. After that, fighting was sporadic until the war ended with the capture of Vladivostok in October 1922, but anti-Bolshevik resistance continued with the Muslim Basmachi movement in Central Asia and Khabarovsk Krai until 1934. There were an estimated 7 to 12 million casualties during the war, mostly civilians.', '2026-01-05 14:51:20', 4, 0, 'public'),
(17, 'Russo-Ukraine War', 'The Russo-Ukrainian War is an ongoing conflict that began in 2014 and escalated in 2022, involving Russia’s invasion of Ukraine', 'The Russo-Ukrainian war began in February 2014 and is ongoing. Following Ukraine\'s Revolution of Dignity, Russia occupied Crimea and annexed it from Ukraine. It then supported Russian-backed armed groups who started a war in the eastern Donbas region against Ukraine\'s military. In 2018, Ukraine declared the region to be occupied by Russia.[8] The first eight years of conflict also involved naval incidents and cyberwarfare. In February 2022, Russia launched a full-scale invasion of Ukraine and began occupying more of the country, starting the current phase of the war, the biggest conflict in Europe since World War II. The war has resulted in a refugee crisis and hundreds of thousands of deaths.\r\n\r\nIn early 2014, the Euromaidan protests led to the Revolution of Dignity and the ousting of Ukraine\'s pro-Russian president Viktor Yanukovych. Shortly after, pro-Russian protests began in parts of southeastern Ukraine, while unmarked Russian troops occupied Crimea. Russia soon annexed Crimea after a highly disputed referendum. In April 2014, Russian-backed militants seized towns and cities in Ukraine\'s eastern Donbas region and proclaimed the Donetsk People\'s Republic (DPR) and the Luhansk People\'s Republic (LPR) as independent states, starting the Donbas war. Russia covertly supported the separatists with its own troops, tanks and artillery, preventing Ukraine from fully retaking the territory. The International Criminal Court (ICC) judged that the war was both a national and international armed conflict involving Russia,[9] and the European Court of Human Rights judged that Russia controlled the DPR and LPR from 2014 onward.[10] In February 2015, Russia and Ukraine signed the Minsk II agreements, but they were never fully implemented in the following years. The Donbas war became a static conflict likened to trench warfare; ceasefires were repeatedly broken but the frontlines did not move.\r\n\r\nBeginning in 2021, there was a massive Russian military buildup near Ukraine\'s borders, including within neighbouring Belarus. Russian officials repeatedly denied plans to attack Ukraine. Russia\'s president Vladimir Putin voiced expansionist views and challenged Ukraine\'s right to exist. He demanded that Ukraine be barred from ever joining the NATO military alliance. Ukraine had been officially a neutral country when the conflict began, but because of Russia\'s attacks it revived plans to join NATO.[11] In early 2022, Russia recognised the DPR and LPR as independent states. While Russian troops surrounded Ukraine, its proxies stepped up attacks on Ukrainian forces in the Donbas.\r\n\r\nOn 24 February 2022, Putin announced a \"special military operation\" to \"demilitarize and denazify\" Ukraine, claiming Russia had no plans to occupy the country. The Russian invasion that followed was internationally condemned; many countries imposed sanctions against Russia, and sent humanitarian and military aid to Ukraine. In the face of fierce resistance, Russia abandoned an attempt to seize Kyiv in early April. In August, Ukrainian forces began liberating territories in the north-east and south. In September, Russia declared the annexation of four partially occupied provinces, which was internationally condemned. Since then, Russian offensives and Ukrainian counteroffensives have gained only small amounts of territory. The invasion has also led to attacks in Russia by Ukrainian and Ukrainian-backed forces, among them a cross-border offensive into Russia\'s Kursk region in August 2024. Russia has repeatedly carried out deliberate and indiscriminate attacks on civilians far from the frontline.[12][13][14] The UN Human Rights Office reported that Russia was committing severe human rights violations in occupied Ukraine.[15] The ICC opened an investigation into war crimes and issued arrest warrants for Putin and several other Russian officials. Russia has repeatedly refused calls for a ceasefire.', '2026-01-05 14:52:59', 4, 0, 'public'),
(18, 'Modern Literature', 'Analysis of 20th-century novels and their cultural impact.', 'Modern literature in the 20th century reflects a period of rapid social, political, and technological change, which deeply influenced the themes and styles of novels from this era. Writers began to move away from traditional storytelling and embraced modernism, focusing on fragmented narratives, inner thoughts, and subjective experiences. Existentialism also became prominent, as authors explored ideas of alienation, loss of meaning, and individual responsibility in a world shaken by war and industrialization. These movements helped literature mirror the uncertainty and complexity of modern life.\r\n\r\nIn The Great Gatsby by F. Scott Fitzgerald, symbolism is used to critique the American Dream and the moral emptiness beneath wealth and glamour. The green light represents Gatsby’s unreachable dreams and hope for the future, while the Valley of Ashes symbolizes moral decay and social inequality. Characters themselves function symbolically, with Gatsby embodying idealism and Daisy representing the illusion of perfection. Through these symbols, Fitzgerald exposes the hollowness of material success in 1920s America.\r\n\r\nGeorge Orwell’s 1984 uses symbolism to highlight the dangers of totalitarianism and the loss of individual freedom. Big Brother symbolizes constant surveillance and oppressive authority, while the telescreens represent the invasion of privacy. The concept of Newspeak shows how language can be manipulated to control thought, reinforcing the novel’s existential concern with identity and truth. Together, these symbols emphasize how power, fear, and control shape human behavior in modern society.', '2026-01-05 14:58:02', 6, 0, 'public'),
(19, 'Fluid Mechanics', 'Principles of fluid statics and dynamics in engineering systems.', 'Fluid Mechanics is a core branch of engineering that studies the behavior of fluids at rest and in motion, focusing on how forces, pressure, and velocity interact within engineering systems. It provides the foundational principles needed to analyze fluid statics and dynamics in applications such as pipelines, pumps, aircraft, and hydraulic machines, making it essential for understanding real-world engineering designs.\r\n\r\nOne of the central concepts in fluid mechanics is Bernoulli’s equation, which explains the relationship between pressure, velocity, and elevation in flowing fluids. This principle is widely applied in practical scenarios such as flow measurement devices, aircraft wing lift, and water supply systems. By using Bernoulli’s equation, engineers can predict how energy is conserved and transferred within a fluid system.\r\n\r\nAnother important aspect covered in fluid mechanics is the calculation of the Reynolds number and pipe flow characteristics. The Reynolds number helps determine whether a flow is laminar or turbulent, which directly affects friction losses and efficiency. Pipe flow analysis further examines factors such as velocity profiles, head loss, and flow resistance, enabling engineers to design safe and efficient fluid transport systems.\r\n', '2026-01-05 14:59:21', 6, 0, 'public'),
(20, 'Discrete Mathematics', 'Study of mathematical structures that are fundamentally discrete.', 'Discrete Mathematics is the study of mathematical structures that are fundamentally separate or “discrete,” rather than continuous, making it essential for understanding concepts in computer science and combinatorial problem-solving. It provides the tools to analyze and model systems where elements are countable, such as networks, algorithms, and logical statements.\r\n\r\nA key area in discrete mathematics is set theory, which deals with the organization and relationships of distinct objects. Alongside this, graph theory examines networks of nodes and edges, helping model problems in computer networking, scheduling, and social networks. Propositional logic and logic gates are also central, enabling students to understand formal reasoning, truth values, and computational logic.\r\n\r\nDiscrete mathematics emphasizes formal proofs and reasoning techniques, which are crucial for computer science students. By mastering concepts like induction, combinatorics, and relations, students can rigorously analyze algorithms, verify correctness, and design efficient computational solutions. This foundation makes discrete mathematics a cornerstone of theoretical and applied computer science.\r\n', '2026-01-05 15:01:46', 7, 0, 'public'),
(21, 'Marketing Strategy', 'Building brand identity and reaching target audiences effectively.', 'Marketing Strategy is the study and practice of creating, communicating, and delivering value to target audiences while building a strong brand identity. It focuses on understanding consumer behavior, market trends, and competitive positioning to make informed business decisions that drive growth and loyalty.\r\n\r\nA core part of marketing strategy involves the 4 Ps: Product, Price, Place, and Promotion. Product covers what is offered to meet customer needs, Price determines the perceived value and profitability, Place addresses distribution channels, and Promotion focuses on communicating the brand message effectively. Together, these elements help businesses craft cohesive strategies that resonate with their audience.\r\n\r\nModern marketing strategy also emphasizes digital marketing and social media campaigns. Case studies in these areas highlight how companies leverage online platforms, content marketing, and analytics to reach and engage consumers in targeted ways. Understanding these strategies equips marketers to adapt to evolving markets and create impactful campaigns that drive measurable results.\r\n', '2026-01-05 15:02:55', 7, 0, 'public'),
(22, 'Anatomy and Physiology', 'Comprehensive look at the human skeletal and muscular systems.', 'Anatomy and Physiology provides a comprehensive study of the human body, focusing on the structure and function of its skeletal and muscular systems. It explores how bones and muscles work together to support movement, maintain posture, and protect vital organs, forming the foundation for understanding human health and physical performance.\r\n\r\nA key topic in this course is the mechanics of muscle contraction, which explains how muscles generate force through the interaction of actin and myosin filaments. Bone tissue growth and remodeling are also covered, highlighting processes like ossification and the role of nutrients and hormones in maintaining bone strength.\r\n\r\nThe course also examines the nervous system’s role in coordinating bodily movements. It explains how signals from the brain and spinal cord regulate muscle activity, reflexes, and voluntary actions. Together, these concepts help students understand how the body functions as an integrated system, providing essential knowledge for fields such as medicine, physiotherapy, and sports science.\r\n', '2026-01-05 15:04:06', 7, 0, 'public'),
(23, 'Microservices Architecture', 'Designing scalable software systems using independent service units.', 'Microservices Architecture is a software design approach in which an application is built as a collection of small, independent services, each responsible for a specific business function. This architecture allows for greater flexibility, scalability, and easier maintenance compared to traditional monolithic applications.\r\n\r\nEach microservice communicates with others through well-defined APIs, enabling teams to develop, deploy, and scale services independently. This modular structure also improves fault isolation, meaning that a failure in one service is less likely to affect the entire system.\r\n\r\nMicroservices Architecture often incorporates practices like containerization, continuous integration/continuous deployment (CI/CD), and cloud-based infrastructure. By breaking applications into smaller, manageable components, organizations can respond faster to changes, update features with minimal disruption, and better handle high-demand workloads.\r\n', '2026-01-05 15:06:15', 7, 0, 'public'),
(24, 'Environmental Science', 'Studying human impact on ecosystems and climate change patterns.', 'Environmental Science is the interdisciplinary study of the natural world and how human activities impact ecosystems, climate, and biodiversity. It combines biology, chemistry, geology, and social sciences to understand environmental processes and the challenges facing the planet.\r\n\r\nA key focus of environmental science is analyzing issues such as pollution, deforestation, climate change, and resource depletion. The field examines how these factors affect air, water, and soil quality, as well as the health of plants, animals, and humans.\r\n\r\nEnvironmental science also emphasizes sustainable solutions and conservation strategies. It explores renewable energy, waste management, environmental policy, and ecosystem restoration, equipping students and professionals to make informed decisions that protect and preserve natural resources for future generations.\r\n', '2026-01-05 15:07:17', 5, 0, 'public'),
(25, 'Psychology 101', 'An introduction to human behavior and mental processes.', 'Psychology 101 is an introductory course that explores the scientific study of human behavior and mental processes. It provides a foundation for understanding how people think, feel, and act in various situations, drawing on research from cognitive, social, developmental, and clinical psychology.\r\n\r\nThe course covers key topics such as perception, learning, memory, motivation, emotion, personality, and mental health. Students learn how biological, psychological, and social factors interact to shape behavior, and how theories and experiments help explain human experiences.\r\n\r\nPsychology 101 also introduces basic research methods, including experiments, observations, and surveys, to help students critically evaluate evidence and understand the scientific approach to studying the mind. This knowledge serves as a basis for more advanced courses in psychology and related fields.\r\n', '2026-01-05 15:08:24', 5, 0, 'public'),
(26, 'Java Programming', 'Object-oriented programming concepts using the Java language.', 'Java Programming is a fundamental course that teaches the principles of writing, compiling, and executing programs using the Java programming language. It emphasizes object-oriented programming concepts, enabling students to create modular, reusable, and efficient code for a variety of applications.\r\n\r\nKey topics in Java programming include variables, data types, operators, control structures (such as loops and conditionals), and methods for organizing code. The course also covers classes, objects, inheritance, polymorphism, and encapsulation, which are essential for designing robust software systems.\r\n\r\nAdditionally, Java programming introduces students to exception handling, file input/output, and basic data structures like arrays and lists. By learning Java, students develop problem-solving skills and gain a strong foundation for building desktop, web, and mobile applications.\r\n', '2026-01-05 15:09:41', 5, 0, 'public'),
(27, 'Classical Philosophy', 'Examining the works of Socrates, Plato, and Aristotle.', 'Classical Philosophy is the study of the foundational ideas and teachings of ancient Greek thinkers, particularly Socrates, Plato, and Aristotle, who shaped the course of Western thought. It explores fundamental questions about knowledge, ethics, reality, and the nature of human life, emphasizing reason and critical inquiry.\r\n\r\nSocrates is examined for his method of questioning and dialogue, which encourages deep reflection and the pursuit of truth. Plato’s works are studied for their ideas on ideal forms, justice, and the structure of society, while Aristotle’s philosophy focuses on logic, ethics, and the natural world, providing systematic approaches to understanding reality.\r\n\r\nBy analyzing these thinkers, students gain insight into the origins of philosophical reasoning and the principles that continue to influence modern thought. Classical Philosophy fosters critical thinking, ethical reflection, and an appreciation for the enduring questions about human existence and knowledge.\r\n', '2026-01-05 15:11:55', 8, 0, 'public');

-- --------------------------------------------------------

--
-- Table structure for table `note_tag`
--

CREATE TABLE `note_tag` (
  `note_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `note_tag`
--

INSERT INTO `note_tag` (`note_id`, `tag_id`) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(2, 12),
(3, 5),
(3, 6),
(3, 7),
(4, 8),
(4, 9),
(5, 5),
(5, 6),
(6, 12),
(6, 13),
(6, 14),
(7, 15),
(7, 16),
(8, 17),
(8, 18),
(8, 19),
(9, 20),
(9, 21),
(10, 1),
(10, 2),
(11, 24),
(11, 25),
(11, 26),
(12, 24),
(12, 27),
(12, 28),
(12, 29),
(13, 24),
(13, 30),
(13, 31),
(14, 24),
(14, 32),
(14, 34),
(15, 24),
(15, 34),
(15, 35),
(16, 24),
(16, 38),
(16, 39),
(17, 24),
(17, 39),
(17, 41),
(18, 24),
(18, 44),
(19, 5),
(19, 6),
(20, 12),
(20, 49),
(21, 15),
(21, 50),
(22, 19),
(22, 52),
(22, 54),
(23, 55),
(23, 56),
(23, 57),
(24, 58),
(24, 59),
(25, 24),
(25, 60),
(26, 2),
(26, 62),
(26, 64),
(27, 65);

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `report_id` int(11) NOT NULL,
  `reporter_id` int(11) NOT NULL,
  `note_id` int(11) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('open','resolved') DEFAULT 'open',
  `reported_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `saved_notes`
--

CREATE TABLE `saved_notes` (
  `user_id` int(11) NOT NULL,
  `note_id` int(11) NOT NULL,
  `swiped_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

CREATE TABLE `tag` (
  `tag_id` int(11) NOT NULL,
  `tag_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tag`
--

INSERT INTO `tag` (`tag_id`, `tag_name`) VALUES
(34, 'America'),
(52, 'Anatomy'),
(56, 'API'),
(8, 'Biochem'),
(19, 'Biology'),
(3, 'Calculus'),
(17, 'Cell'),
(9, 'Chemistry'),
(38, 'Civil War'),
(32, 'Cold War'),
(64, 'CSE'),
(29, 'DDAY'),
(4, 'Discrete Math'),
(49, 'Discrete Maths'),
(1, 'DSA'),
(15, 'Economics'),
(7, 'Engineering'),
(58, 'ENV'),
(20, 'Environment'),
(21, 'Geography'),
(24, 'History'),
(62, 'Java'),
(44, 'Literature'),
(16, 'Macroeconomics'),
(50, 'Marketing'),
(12, 'Maths'),
(5, 'Mechanics'),
(26, 'Medieval'),
(55, 'microservices'),
(28, 'NAZI'),
(31, 'Patriotic War'),
(65, 'Philosophy'),
(6, 'Physics'),
(54, 'Physiology'),
(14, 'Polynomial'),
(2, 'programming'),
(60, 'PSY'),
(25, 'Renaissance'),
(18, 'Respiration'),
(35, 'Revolution'),
(13, 'Root finding'),
(39, 'Russia'),
(59, 'science'),
(57, 'Software'),
(41, 'War'),
(30, 'WW1'),
(27, 'WW2');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `role` enum('user','admin') DEFAULT 'user',
  `points` int(11) DEFAULT 0,
  `rank_level` varchar(50) DEFAULT 'Beginner',
  `status` enum('active','banned') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `name`, `email`, `password`, `created_at`, `role`, `points`, `rank_level`, `status`) VALUES
(1, 'Admin', 'admin_onlynotes@gmail.com', '$2b$10$LCqGb9W1n5ODn3EyAo0Gx.iSVybJ6gC8BaNIsgWJrpGSN0.0Jz1wi', '2026-01-02 18:09:19', 'admin', 0, 'New Uploader', 'active'),
(2, 'mahdi', 'mahdirahman268@gmail.com', '$2b$10$7O9SDS2PZkMN5yChWRPKv.CKyZAkQkFIjQIE1B75hzFG3oiO6jwkq', '2026-01-01 18:15:22', 'user', 230, 'Expert Uploader', 'active'),
(3, 'Paromita', 'paromitarasheeed@gmail.com', '$2b$10$Ooqlm5eGtuUGbHAjrfu2iOJwLsv6TEFiDsHxgHGgAUIyRuiL8TBsW', '2026-01-01 20:01:14', 'user', 80, 'Active Uploader', 'active'),
(4, 'abc', 'qwerty@gmail.com', '$2b$10$5UwPgGMPhI8DlejS8hVOXeGvQEXZ9kElGTaV.C2bNA9qdp.zFYDv6', '2026-01-01 21:39:40', 'user', 0, 'New Uploader', 'active'),
(5, 'muhtasim', 'muhtasim@gmail.com', '$2b$10$aKW.NDUXHM04xvfbLAB8P./dojHDjgk8HRtExZjeaYQaid0rCrL9.', '2026-01-04 11:16:58', 'user', 0, 'New Uploader', 'active'),
(6, 'Alex Carter', 'alex.carter@gmail.com', '$2b$10$//ygKDBGgkwhVcO9IG0EP.ZqOY0mG.sPMCt9/IRIhX0VwlrDIpDjW', '2026-01-05 13:24:42', 'user', 0, 'New Uploader', 'active'),
(7, 'Sarah Khan', 'sarah.khan@gmail.com', '$2b$10$h7ix5CDW3WMtnvIU2v1cp.7MJ/8egxemccNsRi.lksQjEQ.bEnLwK', '2026-01-05 13:30:12', 'user', 0, 'New Uploader', 'active'),
(8, 'Michael Brown', 'michael.brown@gmail.com', '$2b$10$jSV4pVFbWLNbAHvIP5mNjOj5L8ddH.1LgQH0MVL8wM1r7jlOBvgl6', '2026-01-05 13:31:20', 'user', 0, 'New Uploader', 'active'),
(9, 'Emily Johnson', 'emily.johnson@gmail.com', '$2b$10$P0zdYLTyHqXSg58kCECVKuIIO7pAhciM/DQ6thPRj2CD.Rf/aZceO', '2026-01-05 13:32:07', 'user', 0, 'New Uploader', 'active'),
(10, 'Daniel Rahman', 'daniel.rahman@gmail.com', '$2b$10$1RoQAHmDgij5gf.MqbTYyufZg2wKC4VM05FcGhi0cCQrNRzsosjpG', '2026-01-05 13:33:05', 'user', 0, 'New Uploader', 'active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Indexes for table `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`note_id`),
  ADD KEY `fk_note_uploader` (`uploader_id`);

--
-- Indexes for table `note_tag`
--
ALTER TABLE `note_tag`
  ADD PRIMARY KEY (`note_id`,`tag_id`),
  ADD KEY `tag_id` (`tag_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `reporter_id` (`reporter_id`),
  ADD KEY `note_id` (`note_id`);

--
-- Indexes for table `saved_notes`
--
ALTER TABLE `saved_notes`
  ADD PRIMARY KEY (`user_id`,`note_id`),
  ADD KEY `note_id` (`note_id`);

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`tag_id`),
  ADD UNIQUE KEY `tag_name` (`tag_name`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `note`
--
ALTER TABLE `note`
  MODIFY `note_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `tag_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `note`
--
ALTER TABLE `note`
  ADD CONSTRAINT `fk_note_uploader` FOREIGN KEY (`uploader_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `note_tag`
--
ALTER TABLE `note_tag`
  ADD CONSTRAINT `fk_note` FOREIGN KEY (`note_id`) REFERENCES `note` (`note_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tag` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`tag_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `note_tag_ibfk_1` FOREIGN KEY (`note_id`) REFERENCES `note` (`note_id`),
  ADD CONSTRAINT `note_tag_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`tag_id`);

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `reports_ibfk_2` FOREIGN KEY (`note_id`) REFERENCES `note` (`note_id`) ON DELETE CASCADE;

--
-- Constraints for table `saved_notes`
--
ALTER TABLE `saved_notes`
  ADD CONSTRAINT `saved_notes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `saved_notes_ibfk_2` FOREIGN KEY (`note_id`) REFERENCES `note` (`note_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
