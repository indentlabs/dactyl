// var nlp = window.nlp_compromise;
// var editor = new MediumEditor('.editor', {
// 	// TODO: Define custom buttons here - https://github.com/yabwe/medium-editor#mediumeditor-options
//
// 	disableExtraSpaces: 'true',
//
//   toolbar: {
//       allowMultiParagraphSelection: true,
//       buttons: ['bold', 'italic', 'underline', 'anchor', 'h2', 'h3', 'quote'],
//       diffLeft: 0,
//       diffTop: -10,
//       firstButtonClass: 'medium-editor-button-first',
//       lastButtonClass: 'medium-editor-button-last',
//       standardizeSelectionStart: false,
//       static: true,
//       relativeContainer: null,
//       /* options which only apply when static is true */
//       align: 'left',
//       sticky: true,
//       updateOnEmptySelection: true,
//
//       buttons: [
//           'bold',
//           'italic',
//           'underline',
//           {
//               name: 'h1',
//               action: 'append-h2',
//               aria: 'header type 1',
//               tagNames: ['h2'],
//               contentDefault: '<b>H1</b>',
//               classList: ['custom-class-h1'],
//               attrs: {
//                   'data-custom-attr': 'attr-value-h1'
//               }
//           },
//
//           'justifyCenter',
//
//           'orderedlist',
//           'unorderedlist',
//
//           'quote',
//           'anchor',
//           'image'
//       ]
//   },
//
//   keyboardCommands: {
//       commands: [
//           {
//               command: 'bold',
//               key: 'B',
//               meta: true,
//               shift: false,
//               alt: false
//           },
//           {
//               command: 'italic',
//               key: 'I',
//               meta: true,
//               shift: false,
//               alt: false
//           },
//           {
//               command: 'underline',
//               key: 'U',
//               meta: true,
//               shift: false,
//               alt: false
//           }
//       ],
//   },
//   autoLink: true
//
// });
//
// var delta = function(x, y) {
//   // TODO: handle ~ for small numbers
//   if (Math.round(x) < Math.round(y * 0.6)) {
//     return 'up';
//   }
//
//   if (Math.round(x) > Math.round(y * 1.6)) {
//     return 'down';
//   }
//
//   return 'stay';
// };
//
// var syllables_in = function(word) {
//   word = word.toLowerCase();
//   if (word.length <= 3) { return 1; }
//   word = word.replace(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '');
//   word = word.replace(/^y/, '');
//   return (word.match(/[aeiouy]{1,2}/g) || '').length;
// }
//
// editor.subscribe('editableInput', function (event, editable) {
//   // TODO: organize all this better
//   // all in this one func right now so we can abuse memoization and reusing vars
//   var metric, result, target, dir, tip;
//
//   // TODO: this has to be hella inefficient
//   var text = $(editable).text() || '';
//   var html = $(editable).html() || '';
//
//   // stuff to reuse
//   var words = text.split(' '); // TODO: remove '  '
//   var sentences = text.split('.'); // TODO: wrong
//   var paragraphs = (html.split("</p>") || []).length - 1; // TODO: wrong and inefficient
//   var syllables = syllables_in(text); // TODO: probably need to sanitize first
//
//   // pos
//   var adjectives   = [],
//       conjunctions = [],
//       determiners  = [],
//       nouns        = [],
//       prepositions = [],
//       pronouns     = [],
//       verbs        = [];
//
//   // Populate the above in a single loop so it's not ungodly slow
//   nlp.text(text).terms().map(function (word) {
//     // TODO: abstract this out into PoSExtractor or something
//
//     var pos = word['pos'];
//
//     if (pos['Adjective'])   { adjectives.push(word); }
//     if (pos['Conjunction']) { conjunctions.push(word); }
//     if (pos['Determiner'])  { determiners.push(word); }
//     if (pos['Noun'])        { nouns.push(word); }
//     if (pos['Preposition']) { prepositions.push(word); }
//     if (pos['Pronoun'])     { pronouns.push(word); }
//     if (pos['Verb'])        { verbs.push(word); }
//   });
//
//   // ALWAYS_SHOWING metrics
//
//   // word count
//   metric = $('.metric#word_count');
//   result = words.length;
//   metric.find('.current').text(result);
//
//   // estimated reading time
//   metric = $('.metric#estimated_reading_time');
//   result = Math.round(words.length / (200 / 60));
//   metric.find('.current').text(result + ' seconds');
//
//   // Don't start analyzing other metrics until users have at least 50 characters.
//   if (words.length < 20) {
//     $('.metrics').fadeOut();
//     $('#magic-message').fadeIn();
//     return;
//   } else {
//     $('#magic-message').fadeOut();
//     $('.metrics').fadeIn();
//   }
//
//   // Other metrics
//
//   // words per sentence
//   metric = $('.metric#words_per_sentence');
//   result = Math.round(words.length / sentences.length);
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('Try writing more words per sentence. Adjectives are great for this!').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('Try writing fewer words per sentence. Cut out any unneccessary words you can.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
//   // words per paragraph
//   metric = $('.metric#words_per_paragraph');
//   result = Math.round(words.length / paragraphs);
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('Try writing more words per sentence or sentences per paragraph.').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('Try writing fewer words per sentence or sentences per paragraph.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
//   // flsech kincaid grade level
//   metric = $('.metric#flesch_kincaid_grade_level');
//   result = Math.round(0.39 * (words.length / sentences.length) + 11.8 * (syllables / words.length) - 15.59);
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('You can raise your grade level by using larger words and longer sentences.').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('You can lower your grade level by using simpler words and shorter sentences.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
//   // flesch kincaid reading ease
//   metric = $('.metric#flesch_kincaid_reading_ease');
//   result = Math.round(206.835 - 1.015 * (words.length / sentences.length) - (syllables / words.length));
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('You can raise your reading ease by using larger words and longer sentences.').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('You can lower your reading ease by using simpler words and shorter sentences.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
//   // adjective percentage
//   metric = $('.metric#adjective_percentage');
//   result = Math.round(adjectives.length / words.length * 100);
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('Try to be more descriptive with rich adjectives.').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('Try to cut out any unneccessary adjectives.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
//   // conjunction percentage
//   metric = $('.metric#conjunction_percentage');
//   result = Math.round(conjunctions.length / words.length * 100);
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('Try to segway between thoughts with conjunctions.').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('Try to use fewer conjunctions.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
//   // determiner percentage
//   metric = $('.metric#determiner_percentage');
//   result = Math.round(determiners.length / words.length * 100);
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('Try to use more determiners.').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('Try to use fewer determiners.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
//   // noun percentage
//   metric = $('.metric#noun_percentage');
//   result = Math.round(nouns.length / words.length * 100);
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('Try to use more nouns.').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('Try to use fewer nouns.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
//   // prepositions percentage
//   metric = $('.metric#preposition_percentage');
//   result = Math.round(prepositions.length / words.length * 100);
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('Try to use more prepositions.').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('Try to use fewer prepositions.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
//   // pronouns percentage
//   metric = $('.metric#pronoun_percentage');
//   result = Math.round(pronouns.length / words.length * 100);
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('Try to use more pronouns.').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('Try to use fewer pronouns.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
//   // verbs percentage
//   metric = $('.metric#verb_percentage');
//   result = Math.round(verbs.length / words.length * 100);
//   target = metric.find('.target').text();
//   dir = delta(result, target);
//   metric.find('.current').text(result);
//   metric.find('.delta').removeClass().addClass('delta').addClass(dir);
//   if (result < target * 0.6) {
//     metric.find('.tip').text('Try to use more verbs.').fadeIn();
//   } else if (result > target * 1.6) {
//     metric.find('.tip').text('Try to use fewer verbs.').fadeIn();
//   } else {
//     metric.find('.tip').fadeOut();
//   }
//
// });
