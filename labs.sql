CREATE TABLE `rolabs` (
  `id` int(11) NOT NULL,
  `code` longtext,
  `stash` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `rolabs`
  ADD PRIMARY KEY (`id`);
