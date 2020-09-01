-- create user election_us_backenduser with password 'gwitbDr+zp4iK3dn';
GRANT USAGE ON SCHEMA public to  election_us_backenduser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON tables TO election_us_backenduser;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO election_us_backenduser;
GRANT SELECT, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO election_us_backenduser;

CREATE TYPE valg_typer AS ENUM (
    'P',
    'G',
    'H',
    'S'
);


CREATE TABLE blok (
    id serial primary key,
    name character varying(255) NOT NULL
);


CREATE TABLE demo (
    id serial primary key,
    kandidat_id integer,
    name character varying(200),
    party character varying(200),
    title character varying(200),
    birthday character varying(200),
    age integer,
    image character varying(200),
    facebook character varying(200),
    twitter character varying(200),
    children text
);


--
-- Name: kandidat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE kandidat (
    id serial primary key,
    parti_id integer,
    valg_id integer NOT NULL,
    firstname character varying(255) NOT NULL,
    lastname character varying(255) NOT NULL,
    pol_id integer NOT NULL,
    incumbent boolean DEFAULT false NOT NULL,
    ballotorder integer DEFAULT 0 NOT NULL
);

--
-- Name: kandidat_in_state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE kandidat_in_state (
    kandidat_id integer NOT NULL,
    state_id integer NOT NULL,
    valg_id integer NOT NULL
);


CREATE TABLE  manual_state_call (
    valg_id integer NOT NULL,
    parti_id integer NOT NULL,
    state_id integer NOT NULL,
    confirmed boolean, 
    primary key (valg_id,parti_id, state_id)
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE notifications (
    id bigint NOT NULL,
    key character varying(50) NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: parti; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE parti (
    id serial primary key,
    valg_id integer NOT NULL,
    name character varying(255) NOT NULL,
    short_name character varying(255),
    letter character varying(5) NOT NULL
);


--
-- Name: parti_in_blok; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE parti_in_blok (
    valg_id integer NOT NULL,
    parti_id integer NOT NULL,
    blok_id integer NOT NULL
);


--
-- Name: service_manager; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE service_manager (
    id serial primary key,
    host character varying(200) NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    master boolean DEFAULT false
);

create unique index on service_manager (host);
create unique index on service_manager (master) where master = true;


create table valg_senator_seat (
  valg_id integer not null, 
  parti_id integer not null,  
  count integer not null, 
  primary key (valg_id, parti_id)
);
--
-- Name: state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE state (
    id serial primary key,
    name character varying(255) NOT NULL,
    short_name character varying(255)
);
INSERT INTO "state"("id","name","short_name")
VALUES
(0,E'United States',E'US'),
(1,E'Alaska',E'AK'),
(2,E'Alabama',E'AL'),
(3,E'Arkansas',E'AR'),
(4,E'Arizona',E'AZ'),
(5,E'California',E'CA'),
(6,E'Colorado',E'CO'),
(7,E'Connecticut',E'CT'),
(8,E'District of Columbia',E'DC'),
(9,E'Delaware',E'DE'),
(10,E'Florida',E'FL'),
(11,E'Georgia',E'GA'),
(12,E'Hawaii',E'HI'),
(13,E'Iowa',E'IA'),
(14,E'Idaho',E'ID'),
(15,E'Illinois',E'IL'),
(16,E'Indiana',E'IN'),
(17,E'Kansas',E'KS'),
(18,E'Kentucky',E'KY'),
(19,E'Louisiana',E'LA'),
(20,E'Massachusetts',E'MA'),
(21,E'Maryland',E'MD'),
(22,E'Maine',E'ME'),
(23,E'Michigan',E'MI'),
(24,E'Minnesota',E'MN'),
(25,E'Missouri',E'MO'),
(26,E'Mississippi',E'MS'),
(27,E'Montana',E'MT'),
(28,E'North Carolina',E'NC'),
(29,E'North Dakota',E'ND'),
(30,E'Nebraska',E'NE'),
(31,E'New Hampshire',E'NH'),
(32,E'New Jersey',E'NJ'),
(33,E'New Mexico',E'NM'),
(34,E'Nevada',E'NV'),
(35,E'New York',E'NY'),
(36,E'Ohio',E'OH'),
(37,E'Oklahoma',E'OK'),
(38,E'Oregon',E'OR'),
(39,E'Pennsylvania',E'PA'),
(40,E'Rhode Island',E'RI'),
(41,E'South Carolina',E'SC'),
(42,E'South Dakota',E'SD'),
(43,E'Tennessee',E'TN'),
(44,E'Texas',E'TX'),
(45,E'Utah',E'UT'),
(46,E'Virginia',E'VA'),
(47,E'Vermont',E'VT'),
(48,E'Washington',E'WA'),
(49,E'Wisconsin',E'WI'),
(50,E'West Virginia',E'WV'),
(51,E'Wyoming',E'WY');

--
-- Name: v_kandidat_in_state; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW v_kandidat_in_state AS
 SELECT DISTINCT kand.id AS kandidat_id,
    kand.id,
    kand.parti_id,
    kand.valg_id,
    kand.firstname,
    kand.lastname,
    kand.pol_id,
    kand.incumbent,
    kand.ballotorder,
    stat.id AS state_id
   FROM ((kandidat kand
     LEFT JOIN kandidat_in_state kis ON ((kand.id = kis.kandidat_id)))
     LEFT JOIN state stat ON ((stat.id = kis.state_id)));


--
-- Name: valg; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE valg (
    id serial primary key,
    key character varying(25) NOT NULL,
    name character varying(255) NOT NULL,
    type valg_typer NOT NULL,
    creation_date timestamp without time zone DEFAULT now() NOT NULL,
    expire_date timestamp without time zone DEFAULT (now() + '1 mon'::interval) NOT NULL
);


create table results (
    valg_id int not null,
    state_id int not null, 
    kandidat_id int not null, 
    
    precincts_reporting int not null default 0, 
    precincts_total int not null default 0, 
    precincts_reporting_pct float not null default 0, 

    votes int not null default 0, 

    elect_total int not null default 0, 
    elect_won int not null default 0, 
    
    winner boolean not null default false, 
    
    created_at timestamp without time zone default now(), 
    updated_at timestamp without time zone default now(),
    primary key(valg_id, state_id, kandidat_id)
);

CREATE INDEX idx_results_valg_id_state_id ON results(valg_id, state_id);
CREATE INDEX idx_results_valg_id_kandidat_id ON results(valg_id, kandidat_id);
CREATE INDEX idx_results_valg_id_winner ON results(valg_id, winner);
CREATE INDEX idx_results_valg_id ON results(valg_id);

create table state_senator (
   valg_id int not null,
   state_id int not null, 
   parti_id int not null, 
   kandidat_id int not null, 
   confirmed boolean not null default false, 
   primary key(valg_id, state_id, parti_id, kandidat_id)
 );


create table house_representative (
   valg_id int not null,
   state_id int not null, 
   parti_id int not null, 
   kandidat_id int not null, 
   confirmed boolean not null default false, 
   primary key(valg_id, state_id, parti_id,kandidat_id)
 );


create table partier (
   id serial primary key,
   name character varying(255) not null, 
   short_name character varying(255) not null   
);

create view v_sentor_in_parti as 
select ss.valg_id, p.short_name,confirmed, count(1) from state_senator ss, partier p where p.id = ss.parti_id group by 1, 2, 3 order by 2 desc;

create view v_representative_in_parti as 
select ss.valg_id, p.short_name, confirmed,  count(1) from house_representative ss, partier p where p.id = ss.parti_id group by 1, 2, 3 order by 2 desc;

create view v_senator_seats as 
select ss.valg_id, p.short_name,ss.count from valg_senator_seat ss, partier p where p.id = ss.parti_id order by 3 desc;



INSERT INTO "partier"("id","name","short_name")
VALUES
(1,E'A Connecticut Party',E'ACP'),
(2,E'American First Coalition',E'AFC'),
(3,E'American Freedom Party',E'AFP'),
(4,E'American Heritage Party',E'AHP'),
(5,E'American Independent Pty',E'AIP'),
(6,E'Alaskan Independence',E'AKI'),
(7,E'American Third Position',E'ATP'),
(8,E'American Constitution',E'AMC'),
(9,E'American Dream',E'AMD'),
(10,E'Americans Elect',E'AME'),
(11,E'America First',E'AMF'),
(12,E'Americas Party',E'AMP'),
(13,E'American',E'AMR'),
(14,E'Blue Enigma Party',E'BEP'),
(15,E'Better for America',E'BFA'),
(16,E'Builders Party',E'BLD'),
(17,E'Better Schools',E'BSC'),
(18,E'Boston Tea',E'BOT'),
(19,E'Best',E'BST'),
(20,E'Buchanan Reform',E'BUC'),
(21,E'Concerned Citizens',E'CC'),
(22,E'Centrist Party',E'CEN'),
(23,E'Citizens First',E'CF'),
(24,E'Connecticut Independent',E'CIP'),
(25,E'Cool Moose',E'CM'),
(26,E'Camp. for a New Tomorrow',E'CNT'),
(27,E'Constitution',E'CST'),
(28,E'CT for Lieberman',E'CTL'),
(29,E'Concerns of People',E'CNP'),
(30,E'Constitutional',E'CNL'),
(31,E'Conservative',E'CON'),
(32,E'Politicians are Crooks',E'CRK'),
(33,E'Descendants of American',E'DAS'),
(34,E'DC Statehood Green Party',E'DCG'),
(35,E'Democrat',E'DEM'),
(36,E'Ecology Party of Florida',E'EPF'),
(37,E'Economic Recovery Party',E'ERP'),
(38,E'End Suffolk Legislature',E'ESL'),
(39,E'Fair',E'FAA'),
(40,E'Free Energy Party',E'FEP'),
(41,E'Fusion Independent',E'FIN'),
(42,E'Future Now Party',E'FNP'),
(43,E'Farmers & Small Business',E'FSB'),
(44,E'Freedom Socialist',E'FSO'),
(45,E'Family Values Party',E'FVP'),
(46,E'Friends United',E'FRU'),
(47,E'Freedom',E'FRE'),
(48,E'Green Coalition Party',E'GCP'),
(49,E'Greens No To War',E'GNW'),
(50,E'Republican',E'GOP'),
(51,E'Grass Roots Party',E'GRP'),
(52,E'Green',E'GRN'),
(53,E'Healthcare Party',E'HCP'),
(54,E'Home Protection',E'HP'),
(55,E'Heartquake 08',E'HQ8'),
(56,E'Harold Washington Party',E'HWP'),
(57,E'Independent American',E'IAP'),
(58,E'Ind. Christian Profile',E'ICP'),
(59,E'Ind. for Econ. Recovery',E'IER'),
(60,E'Independent Fusion',E'IF'),
(61,E'Independent Grassroots',E'IG'),
(62,E'Independent Green',E'IGR'),
(63,E'Independent Reform Party',E'INR'),
(64,E'Integrity Party',E'INT'),
(65,E'Independent Party',E'IP'),
(66,E'Independent Peoples Coal',E'IPC'),
(67,E'Independent Party of DE',E'IPD'),
(68,E'Independent Party of HI',E'IPH'),
(69,E'Independent Party of UT',E'IPU'),
(70,E'Independent-Progressive',E'IPR'),
(71,E'Ind. Save Our Children',E'ISC'),
(72,E'Independent Voters',E'IVP'),
(73,E'Independent',E'IND'),
(74,E'Independence',E'INP'),
(75,E'Justice Party',E'JP'),
(76,E'Jobs Property Rights',E'JPR'),
(77,E'Looking Back Party',E'LBP'),
(78,E'Labor and Farm',E'LFM'),
(79,E'Long Island First',E'LIF'),
(80,E'Legal Marijuana Now',E'LMN'),
(81,E'Legalize Marijuana',E'LMJ'),
(82,E'Louisiana Taxpayers',E'LTP'),
(83,E'Liberty Union/Progressiv',E'LUP'),
(84,E'Liberty Union',E'LUN'),
(85,E'Labor Party',E'LAB'),
(86,E'Liberal',E'LBL'),
(87,E'Libertarian',E'LIB'),
(88,E'Moderate Citizens Accnt.',E'MCA'),
(89,E'Maryland Independent Par',E'MIP'),
(90,E'Marijuana Party',E'MJP'),
(91,E'Make Marijuana Legal',E'MML'),
(92,E'Marijuana Reform Party',E'MRP'),
(93,E'Mississippi Taxpayers',E'MTP'),
(94,E'Mountain Party',E'MNT'),
(95,E'Moderate Party',E'MOD'),
(96,E'New Alliance',E'NAL'),
(97,E'No Home Heat Tax',E'NHT'),
(98,E'New Jersey Conservative',E'NJC'),
(99,E'New Jersey Independents',E'NJI'),
(100,E'Natural Law Party',E'NLP'),
(101,E'New Mexico Independent P',E'NMI'),
(102,E'No New Taxes',E'NNT'),
(103,E'Non-Partisan',E'NP'),
(104,E'No Party Affiliation',E'NPA'),
(105,E'No Party Designation',E'NPD'),
(106,E'NO PARTY PREFERENCE',E'NPP'),
(107,E'Nutritional Rights Allnc',E'NRA'),
(108,E'Nebraska',E'NEB'),
(109,E'New',E'NEW'),
(110,E'No',E'NO'),
(111,E'National Labor Party',E'NTL'),
(112,E'New Perspective',E'NWP'),
(113,E'128 District',E'OTE'),
(114,E'Orange Taxpayers',E'OTX'),
(115,E'Objectivist',E'OBJ'),
(116,E'One Earth',E'ONE'),
(117,E'Open',E'OPN'),
(118,E'Other',E'OTH'),
(119,E'Pacific Green',E'PAG'),
(120,E'Pro-Bethel',E'PBL'),
(121,E'Pacifist',E'PCF'),
(122,E'Personal Choice',E'PCH'),
(123,E'Petitioning Candidate',E'PEC'),
(124,E'Party of Ethics & Tradit',E'PET'),
(125,E'Peace and Freedom',E'PFP'),
(126,E'Peace and Justice',E'PJP'),
(127,E'Pro Life Conservative',E'PLC'),
(128,E'New Progressive Party',E'PNP'),
(129,E'Peace Party of Oregon',E'PPO'),
(130,E'Preserve Our Town',E'PRT'),
(131,E'Party for Socialism and',E'PSL'),
(132,E'Property Tax Cut',E'PTC'),
(133,E'People of Vermont',E'PV'),
(134,E'Protect Working Families',E'PWF'),
(135,E'Pacific',E'PAC'),
(136,E'Patriot Party',E'PAT'),
(137,E'Populist',E'POP'),
(138,E'Protecting Freedom',E'PRF'),
(139,E'Pro Life',E'PRL'),
(140,E'Progressive',E'PRG'),
(141,E'Prohibition',E'PRO'),
(142,E'Randolph for Congress',E'RFC'),
(143,E'Restore Justice-Freedom',E'RJF'),
(144,E'Reform Minnesota',E'RM'),
(145,E'Running on Principles',E'ROP'),
(146,E'Reform Party',E'RP'),
(147,E'Right to Life',E'RTL'),
(148,E'Resource Party',E'RES'),
(149,E'Republican Moderate',E'RPM'),
(150,E'Socialism',E'SCL'),
(151,E'Socialist Equality',E'SEP'),
(152,E'American Shopping Party',E'SHP'),
(153,E'Save Medicare',E'SM'),
(154,E'Socialist USA',E'SPU'),
(155,E'Save Social Security',E'SSS'),
(156,E'Star Tax Cut',E'STC'),
(157,E'Socialist Workers Party',E'SWP'),
(158,E'School Choice',E'SCC'),
(159,E'Save Seniors',E'SEN'),
(160,E'Socialist',E'SOC'),
(161,E'Student First',E'STF'),
(162,E'Statehood Party',E'STA'),
(163,E'The American Party',E'TAP'),
(164,E'To Be Determined',E'TBD'),
(165,E'The Better Life',E'TBL'),
(166,E'Tax Cut',E'TC'),
(167,E'Tax Cut Now',E'TCN'),
(168,E'Tea Party',E'TEA'),
(169,E'The Go',E'TGO'),
(170,E'Truth Life Liberty',E'TLL'),
(171,E'Term Limits',E'TLM'),
(172,E'Timesizing',E'TS'),
(173,E'The 3rd Party',E'TTP'),
(174,E'United Advocacy',E'UAD'),
(175,E'United Citizen',E'UCZ'),
(176,E'United',E'UNT'),
(177,E'U.S. Taxpayers Party',E'UST'),
(178,E'Unaffiliated',E'UNA'),
(179,E'Undauntable Stalwart All',E'UND'),
(180,E'United Independent',E'UNI'),
(181,E'Unenrolled',E'UNR'),
(182,E'Unity',E'UTY'),
(183,E'Veterans Party',E'VET'),
(184,E'Vermont Grassroots',E'VG'),
(185,E'Voice of the People',E'VOP'),
(186,E'Voters Rights Party',E'VRP'),
(187,E'Working Class Party',E'WCP'),
(188,E'Womens Equality Party',E'WEQ'),
(189,E'Working Families',E'WF'),
(190,E'West Side Neighbors',E'WSN'),
(191,E'We the People',E'WTP'),
(192,E'Workers for Vermont',E'WV'),
(193,E'Workers World',E'WW'),
(194,E'Wyoming Country Party',E'WYC'),
(195,E'Wisconsin Taxpayers Pty',E'WIT'),
(196,E'Yes',E'YES');








--
-- Data for Name: blok; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "blok"("id","name")
VALUES
(0,E'none'),
(1,E'Republican'),
(2,E'Democrats');

INSERT INTO "valg_senator_seat"("valg_id","parti_id","count")
VALUES
(1,1,34),
(1,2,30),
(1,10,2);


INSERT INTO "demo"("id","kandidat_id","name","party","title","birthday","age","image","facebook","twitter","children")
VALUES
(39,0,E'Amy Klobuchar',E'Democratic Party',E'U.S. Senator, Minnesota',E'May 25, 1960',56,E'https://s3.graphiq.com/sites/default/files/980/media/images/Amy_Klobuchar_1786278.jpg',E'https://facebook.com/amyklobuchar',E'https://twitter.com/@amyklobuchar',E'[Abigail]'),
(40,0,E'Andrew Cuomo',E'Democratic Party',E'Governor of New York',E'December 6, 1957',58,E'https://s3.graphiq.com/sites/default/files/980/media/images/Andrew_Cuomo_1786279.jpg',E'https://facebook.com/andrewcuomo2010',E'https://twitter.com/@NYGovCuomo',E'[Mariah, Cara, Michaela]'),
(41,0,E'Ben Carson',E'Republican Party',E'Former Neurosurgeon',E'September 18, 1951',65,E'https://s3.graphiq.com/sites/default/files/980/media/images/Ben_Carson_6036997.jpg',E'https://facebook.com/realbencarson',E'https://twitter.com/@RealBenCarson',E'[Ben Jr., Rhoeyce, Murray]'),
(42,0,E'Bernie Sanders',E'Democratic Party',E'U.S. Senator, Vermont',E'September 7, 1941',75,E'https://s3.graphiq.com/sites/default/files/980/media/images/Bernie_Sanders_1786280.jpg',E'https://facebook.com/senatorsanders',E'https://twitter.com/@SenSanders',E'[Levi]'),
(43,0,E'Bobby Jindal',E'Republican Party',E'Governor of Louisiana',E'June 10, 1971',45,E'https://s3.graphiq.com/sites/default/files/980/media/images/Bobby_Jindal_1786297.jpg',E'https://facebook.com/bobbyjindal',E'https://twitter.com/@BobbyJindal',E'[Slade, Shaan, Selia]'),
(44,0,E'Brian Schweitzer',E'Democratic Party',E'Former Governor of Montana',E'September 4, 1955',61,E'https://s3.graphiq.com/sites/default/files/980/media/images/Brian_Schweitzer_1786281.jpg',NULL,E'https://twitter.com/@brianschweitzer',E'[Ben, Khai, Katrina]'),
(45,0,E'Carly Fiorina',E'Republican Party',E'Former CEO of HP',E'September 6, 1954',62,E'https://s3.graphiq.com/sites/default/files/980/media/images/Carly_Fiorina_6036992.jpg',E'https://facebook.com/CarlyFiorina',E'https://twitter.com/@carlyfiorina',E'[Traci, Lori Ann]'),
(46,0,E'Chris Christie',E'Republican Party',E'Governor of New Jersey',E'September 6, 1962',54,E'https://s3.graphiq.com/sites/default/files/980/media/images/Chris_Christie_1786282.jpg',E'https://facebook.com/govchristie',E'https://twitter.com/@GovChristie',E'[Andrew, Sarah, Patrick, Bridget]'),
(47,2,E'Donald Trump',E'Republican Party',E'President, Trump Organization',E'June 13, 1946',70,E'https://s3.graphiq.com/sites/default/files/980/media/images/Donald_Trump_6522122.jpg',E'https://facebook.com/DonaldTrump',E'https://twitter.com/@realDonaldTrump',E'[Donald Jr., Ivanka, Eric, Tiffany, Barron]'),
(48,0,E'Elizabeth Warren',E'Democratic Party',E'U.S. Senator, Massachusetts',E'June 22, 1949',67,E'https://s3.graphiq.com/sites/default/files/980/media/images/Elizabeth_Warren_1786249.jpg',E'https://facebook.com/ElizabethWarren',E'https://twitter.com/@SenWarren',E'[Amelia, Alex]'),
(49,3,E'Gary Johnson',E'Libertarian Party',E'Former Governor of New Mexico',E'January 1, 1953',63,E'https://s3.graphiq.com/sites/default/files/980/media/images/Gary_Johnson_1786250.jpg',E'https://facebook.com/govgaryjohnson',E'https://twitter.com/@GovGaryJohnson',E'[Seah, Erik]'),
(50,0,E'George Pataki',E'Republican Party',E'Former Governor of New York',E'June 24, 1945',71,E'https://s3.graphiq.com/sites/default/files/980/media/images/George_Pataki_6502634.jpg',E'https://facebook.com/GovGeorgePataki',E'https://twitter.com/@GovernorPataki',E'[Emily, Teddy, Allison, Owen]'),
(51,1,E'Hillary Clinton',E'Democratic Party',E'Former Secretary of State',E'October 25, 1947',68,E'https://s3.graphiq.com/sites/default/files/980/media/images/Hillary_Clinton_1786283.jpg',E'https://facebook.com/hillaryclinton',E'https://twitter.com/@HillaryClinton',E'[Chelsea]'),
(52,0,E'Howard Dean',E'Democratic Party',E'Former Governor of Vermont',E'November 16, 1948',67,E'https://s3.graphiq.com/sites/default/files/980/media/images/Howard_Dean_1786284.jpg',NULL,E'https://twitter.com/@GovHowardDean',E'[Anne, Paul]'),
(53,0,E'Jan Brewer',E'Republican Party',E'Governor of Arizona',E'September 26, 1944',71,E'https://s3.graphiq.com/sites/default/files/980/media/images/Jan_Brewer_1786286.jpg',E'https://facebook.com/GovJanBrewer',E'https://twitter.com/@govbrewer',E'[]'),
(54,0,E'Jeb Bush',E'Republican Party',E'Former Governor of Florida',E'February 11, 1953',63,E'https://s3.graphiq.com/sites/default/files/980/media/images/Jeb_Bush_1786288.jpg',E'https://facebook.com/jebbush',E'https://twitter.com/@JebBush',E'[George, John, Noelle]'),
(55,4,E'Jill Stein',E'Green Party',E'Physician',E'May 14, 1950',66,E'https://s3.graphiq.com/sites/default/files/980/media/images/Jill_Stein_1786255.jpg',E'https://facebook.com/drjillstein',E'https://twitter.com/@DrJillStein',E'[Ben, Noah]'),
(56,0,E'Jim Gilmore',E'Republican Party',E'Former Governor of Virginia',E'October 5, 1949',66,E'https://s3.graphiq.com/sites/default/files/980/media/images/Jim_Gilmore_6638843.jpg',NULL,E'https://twitter.com/@gov_gilmore',E'[Ashton, Jay]'),
(57,0,E'Jim Webb',E'Democratic Party',E'Former U.S. Senator, Virginia',E'February 8, 1946',70,E'https://s3.graphiq.com/sites/default/files/980/media/images/Jim_Webb_6387898.jpg',E'https://facebook.com/IHeardMyCountryCalling',E'https://twitter.com/@JimWebbUSA',E'[Amy, Jimmy, Sarah, Julia, Georgia, Emily]'),
(58,0,E'Joe Biden',E'Democratic Party',E'Vice President of the United States',E'November 20, 1942',73,E'https://s3.graphiq.com/sites/default/files/980/media/images/Joe_Biden_1786290.jpg',E'https://facebook.com/joebiden',E'https://twitter.com/@JoeBiden',E'[Beau, Hunter, Ashley, Naomi (deceased)]'),
(59,0,E'John Kasich',E'Republican Party',E'Governor of Ohio',E'May 13, 1952',64,E'https://s3.graphiq.com/sites/default/files/980/media/images/John_Kasich_1786289.jpg',E'https://facebook.com/JohnRKasich',E'https://twitter.com/@JohnKasich',E'[Emma, Reese]'),
(60,0,E'John R. Bolton',E'Republican Party',E'Former U.S. Ambassador to the United Nations',E'November 18, 1948',67,E'https://s3.graphiq.com/sites/default/files/980/media/images/John_R_Bolton_1786287.jpg',E'https://facebook.com/AmbBolton',E'https://twitter.com/@AmbJohnBolton',E'[]'),
(61,0,E'Kirsten Gillibrand',E'Democratic Party',E'U.S. Senator, New York',E'December 9, 1966',49,E'https://s3.graphiq.com/sites/default/files/980/media/images/Kirsten_Gillibrand_1786291.jpg',E'https://facebook.com/KirstenGillibrand',E'https://twitter.com/@SenGillibrand',E'[Theodore, Henry]'),
(62,0,E'Lincoln Chafee',E'Democratic Party',E'Former Governor of Rhode Island',E'March 25, 1953',63,E'https://s3.graphiq.com/sites/default/files/980/media/images/Lincoln_Chafee_6387900.jpg',E'https://facebook.com/chafee2016',E'https://twitter.com/@LincolnChafee',E'[Louisa, Caleb, Thea]'),
(63,0,E'Lindsey Graham',E'Republican Party',E'U.S. Senator, South Carolina',E'July 9, 1955',61,E'https://s3.graphiq.com/sites/default/files/980/media/images/Lindsey_Graham_6387899.jpg',E'https://facebook.com/LindseyGrahamSC',E'https://twitter.com/@LindseyGrahamSC',E'[]'),
(64,0,E'Marco Rubio',E'Republican Party',E'U.S. Senator, Florida',E'May 28, 1971',45,E'https://s3.graphiq.com/sites/default/files/980/media/images/Marco_Rubio_1786292.jpg',E'https://facebook.com/MarcoRubio',E'https://twitter.com/@marcorubio',E'[Amanda, Daniella, Anthony, Dominic]'),
(65,0,E'Martin O\'Malley',E'Democratic Party',E'Former Governor of Maryland',E'January 18, 1963',53,E'https://s3.graphiq.com/sites/default/files/980/media/images/Martin_OMalley_1786293.jpg',E'https://facebook.com/MartinOMalley',E'https://twitter.com/@martinomalley',E'[Grace, Tara, William, Jack]'),
(66,0,E'Mike Huckabee',E'Republican Party',E'Former Governor of Arkansas',E'August 24, 1955',61,E'https://s3.graphiq.com/sites/default/files/980/media/images/Mike_Huckabee_1786294.jpg',E'https://facebook.com/mikehuckabee',E'https://twitter.com/@govmikehuckabee',E'[John Mark, David, Sarah]'),
(67,0,E'Mike Pence',E'Republican Party',E'Governor of Indiana',E'June 7, 1959',57,E'https://s3.graphiq.com/sites/default/files/980/media/images/Mike_Pence_1786264.jpg',E'https://facebook.com/mikepence',E'https://twitter.com/@GovPenceIN',E'[Michael, Charlotte, Audrey]'),
(68,0,E'Paul Ryan',E'Republican Party',E'U.S. Representative, 1st District of Wisconsin',E'January 29, 1970',46,E'https://s3.graphiq.com/sites/default/files/980/media/images/Paul_Ryan_1786295.png',E'https://facebook.com/Ryan4Congress',E'https://twitter.com/@PRyan',E'[Elizabeth, Charles, Samuel]'),
(69,0,E'Pete King',E'Republican Party',E'U.S. Representative, 2nd District of New York',E'April 5, 1944',72,E'https://s3.graphiq.com/sites/default/files/980/media/images/Pete_King_1786296.jpg',E'https://facebook.com/reppeteking',E'https://twitter.com/@RepPeteKing',E'[Sean, Erin]'),
(70,0,E'Rand Paul',E'Republican Party',E'U.S. Senator, Kentucky',E'January 7, 1963',53,E'https://s3.graphiq.com/sites/default/files/980/media/images/Rand_Paul_5645560.jpg',E'https://facebook.com/RandPaul',E'https://twitter.com/@RandPaul',E'[Will, Duncan, Robert]'),
(71,0,E'Rick Perry',E'Republican Party',E'Former Governor of Texas',E'March 4, 1950',66,E'https://s3.graphiq.com/sites/default/files/980/media/images/Rick_Perry_1786285.jpg',E'https://facebook.com/GovernorPerry',E'https://twitter.com/@GovernorPerry',E'[Griffin, Sydney]'),
(72,0,E'Rick Santorum',E'Republican Party',E'Former U.S. Senator, Pennsylvania',E'May 10, 1958',58,E'https://s3.graphiq.com/sites/default/files/980/media/images/Rick_Santorum_1786299.jpg',E'https://facebook.com/RickSantorum',E'https://twitter.com/@ricksantorum',E'[Elizabeth, John, Daniel, Sarah Maria, Peter, Patrick, Isabella]'),
(73,0,E'Scott Brown',E'Republican Party',E'Former U.S. Senator, Massachusetts',E'September 12, 1959',57,E'https://s3.graphiq.com/sites/default/files/980/media/images/Scott_Brown_1786300.jpg',E'https://facebook.com/ScottBrownMA',E'https://twitter.com/@senscottbrown',E'[Ayla, Arianna]'),
(74,0,E'Scott Walker',E'Republican Party',E'Governor of Wisconsin',E'November 2, 1967',48,E'https://s3.graphiq.com/sites/default/files/980/media/images/Scott_Walker_1786302.jpg',E'https://facebook.com/scottkwalker',E'https://twitter.com/@scottwalker',E'[Max, Alex]'),
(75,0,E'Steve King',E'Republican Party',E'U.S. Representative, 4th District of Iowa',E'May 28, 1949',67,E'https://s3.graphiq.com/sites/default/files/980/media/images/Steve_King_1786301.jpg',E'https://facebook.com/KingforCongress',E'https://twitter.com/@stevekingia',E'[David, Michael, Jeff]'),
(76,0,E'Ted Cruz',E'Republican Party',E'U.S. Senator, Texas',E'December 22, 1970',45,E'https://s3.graphiq.com/sites/default/files/980/media/images/Ted_Cruz_1786303.jpg',E'https://facebook.com/tedcruzpage',E'https://twitter.com/@tedcruz',E'[Caroline, Catherine]');
